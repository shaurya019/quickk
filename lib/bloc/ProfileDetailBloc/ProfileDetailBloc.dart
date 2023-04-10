import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/Utils/Validations/Email.dart';
import 'package:quickk/Utils/Validations/FirstName.dart';
import 'package:quickk/Utils/Validations/LastName.dart';
import 'package:quickk/Utils/Validations/MobileNumber.dart';
import 'package:quickk/modal/UserData.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
import 'package:quickk/repository/ProfileDetailRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'ProfileDetailEvent.dart';
part 'ProfileDetailState.dart';

class ProfileDetailBloc extends Bloc<ProfileDetailEvent, ProfileDetailState> {
  ProfileDetailRepository repository;

  ProfileDetailBloc(this.repository)
      : super(const ProfileDetailInitialState(version: 0)) {
    on<SaveProfileDetailEvent>(_handleSaveProfileDetailEvent,
        transformer: sequential());
    on<FirstNameChanged>(_handleFirstNameChanged, transformer: sequential());
    on<LastNameChanged>(_handleLastNameChanged, transformer: sequential());
    on<EmailChanged>(_handleEmailChanged, transformer: sequential());
    on<EditProfileDetailEvent>(_handleEditProfileDetailEvent,
        transformer: sequential());
    on<DocumentUploadEvent>(_handleDocumentUploadEvent,
        transformer: sequential());
  }

  void _handleSaveProfileDetailEvent(
      SaveProfileDetailEvent event, Emitter<ProfileDetailState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.status.isValidated) {
      DialogUtil.showProgressDialog("", event.context);
      Response serverAPIResponseDto = await repository.saveProfileData(
          event.context,
          event.firstName,
          event.lastName,
          event.emailId,
          event.mobileNumber,
          event.prefx,
          event.userType);
      DialogUtil.dismissProgressDialog(event.context);
      if (serverAPIResponseDto != null &&
          (serverAPIResponseDto.data["status"].toString() == "200" ||
              serverAPIResponseDto.data["status"].toString() == "201")) {
        if (serverAPIResponseDto.data["data"] != null) {
          print("serverAPIResponseDto===>>" +
              serverAPIResponseDto.data.toString() +
              'manoj');
          Map<String, dynamic> dataDto =
              serverAPIResponseDto.data as Map<String, dynamic>;
          UserData newData = UserData.fromJson(dataDto["data"]);
          UserDataService userDataService = getIt<UserDataService>();
          prefs.setString('userData', jsonEncode(newData));
          userDataService.setUserdata(newData);
        }
        ProfileDetailCompleteState completeState =
            new ProfileDetailCompleteState(
                context: event.context, version: state.version + 1);
        emit(completeState);
      } else {
        ProfileDetailInitialState completeState = new ProfileDetailInitialState(
            context: event.context, version: state.version + 1);
        emit(completeState);
      }
    }
  }

  void _handleFirstNameChanged(
      FirstNameChanged event, Emitter<ProfileDetailState> emit) {
    final firstName = FirstName.dirty(event.firstName);
    emit(state.copyWith(
        firstName:
            firstName.valid ? firstName : FirstName.pure(event.firstName),
        status: Formz.validate([firstName]),
        version: state.version + 1));
  }

  void _handleLastNameChanged(
      LastNameChanged event, Emitter<ProfileDetailState> emit) {
    final lastName = LastName.dirty(event.lastName);
    emit(state.copyWith(
        lastName: lastName.valid ? lastName : Email.pure(event.lastName),
        status: Formz.validate([state.firstName, lastName]),
        version: state.version + 1));
  }

  void _handleEmailChanged(
      EmailChanged event, Emitter<ProfileDetailState> emit) {
    final email = Email.dirty(event.email);
    emit(state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([email]),
        version: state.version + 1));
  }

  void _handleEditProfileDetailEvent(
      EditProfileDetailEvent event, Emitter<ProfileDetailState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state.status.isValidated) {
      DialogUtil.showProgressDialog("", event.context);
      Response serverAPIResponseDto = await repository.editProfileData(
          event.context,
          event.firstName,
          event.lastName,
          event.emailId,
          event.prefx,
          event.userId,
          event.imageFile);
      DialogUtil.dismissProgressDialog(event.context);
      print("serverAPIResponseDto===>>>" + serverAPIResponseDto.toString());
      if (serverAPIResponseDto != null &&
          (serverAPIResponseDto.data["status"].toString() == "200" ||
              serverAPIResponseDto.data["status"].toString() == "201")) {
        if (serverAPIResponseDto.data["data"] != null) {
          Map<String, dynamic> dataDto =
              serverAPIResponseDto.data as Map<String, dynamic>;
          UserData newData = UserData.fromJson(dataDto["data"]);
          UserDataService userDataService = getIt<UserDataService>();
          prefs.setString('userData', jsonEncode(newData));
          userDataService.setUserdata(newData);
        }
        ProfileDetailCompleteState completeState =
            new ProfileDetailCompleteState(
                context: event.context, version: state.version + 1);
        emit(completeState);
      } else {
        ProfileDetailInitialState completeState = new ProfileDetailInitialState(
            context: event.context, version: state.version + 1);
        emit(completeState);
      }
    }
  }

  void _handleDocumentUploadEvent(
      DocumentUploadEvent event, Emitter<ProfileDetailState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.documentUpload(
        event.context,
        event.imageFile,
        event.documentFile,
        event.documentId1,
        event.documentId2,
        event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      DocumentCompleteState completeState = new DocumentCompleteState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    } else {}
  }
}
