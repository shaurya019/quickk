import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:formz/formz.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/Utils/Validations/MobileNumber.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
part 'EnterNumberEvent.dart';
part 'EnterNumberState.dart';

class EnterNumberBloc extends Bloc<EnterNumberEvent, EnterNumberState> {
  EnterNumberRepository repository;

  EnterNumberBloc(this.repository)
      : super(const EnterNumberInitialState(version: 0)) {
    on<SendOTPEvent>(_handleSendOTPEvent, transformer: sequential());
    on<MobileNumberChanged>(_handleMobileNumberChanged,
        transformer: sequential());
  }

  void _handleSendOTPEvent(
      SendOTPEvent event, Emitter<EnterNumberState> emit) async {
    EnterNumberState currentState = state as EnterNumberState;
    if (currentState.status.isValidated) {
      DialogUtil.showProgressDialog("", event.context);
      Response serverAPIResponseDto =
          await repository.sendOTP(event.context, event.mobileNumber);
      DialogUtil.dismissProgressDialog(event.context);
      if (serverAPIResponseDto != null &&
          serverAPIResponseDto.data["status"].toString() == "200") {
        print("success======>>>" +
            serverAPIResponseDto.data["messages"]["success"].toString());
        Fluttertoast.showToast(
            msg: serverAPIResponseDto.data["messages"]["success"].toString(),
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 20.sp);
        EnterNumberCompleteState completeState = new EnterNumberCompleteState(
            context: event.context,
            version: state.version + 1,
            mobileNumber: MobileNumber.pure(event.mobileNumber),
            formzStatus: currentState.status);
        emit(completeState);
      }
    }
  }

  void _handleMobileNumberChanged(
      MobileNumberChanged event, Emitter<EnterNumberState> emit) {
    final mobileNumber = MobileNumber.dirty(event.mobileNumber);

    emit(state.copyWith(
        mobileNumber: mobileNumber.valid
            ? mobileNumber
            : MobileNumber.pure(event.mobileNumber),
        status: Formz.validate([mobileNumber]),
        version: state.version + 1));
  }
}
