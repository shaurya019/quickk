import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/modal/LocationData.dart';
import 'package:quickk/modal/UserData.dart';
import 'package:quickk/repository/OTPVerificationRepository.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:shared_preferences/shared_preferences.dart';




part 'OTPVerificationEvent.dart';
part 'OTPVerificationState.dart';

class OTPVerificationBloc extends Bloc<OTPVerificationEvent, OTPVerificationState> {
  OTPVerificationRepository repository;


  OTPVerificationBloc(this.repository) : super(const OTPVerificationInitialState(version: 0)){
    on<VerifyOTPEvent>(_handleVerifyOTPEvent, transformer: sequential());

  }

  void _handleVerifyOTPEvent(VerifyOTPEvent event, Emitter<OTPVerificationState> emit) async{
    bool isRegistered = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto = await repository.verifyOTP(event.context,event.mobileNumber,event.otpNumber);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null && (serverAPIResponseDto.data["status"].toString() == "200" || serverAPIResponseDto.data["status"].toString() == "201")){
        if(serverAPIResponseDto.data["data1"] != null){
          isRegistered = true;
          Map<String, dynamic> dataDto = serverAPIResponseDto.data as Map<String, dynamic>;
          UserData newData = UserData.fromJson(dataDto["data1"]);
          UserDataService userDataService =  getIt<UserDataService>();
          prefs.setString('userData', jsonEncode(newData));
          userDataService.setUserdata(newData);
          if(dataDto["data2"] != null){
            LocationData newData2 = LocationData.fromJson(dataDto["data2"]);
            prefs.setString('locationData', jsonEncode(newData2));
            LocationDataService locationDataService =  getIt<LocationDataService>();
            locationDataService.setLocationData(newData2);
          }
        }

        OTPVerificationCompleteState completeState = new OTPVerificationCompleteState(context: event.context , version: state.version+1,isRegistered:isRegistered);
        emit(completeState);
    }
    else{
       DialogUtil.showInfoDialog("Wrong OTP","You've entered wrong OTP.",event.context);
       OTPVerificationState completeState = new OTPVerificationState(version: state.version+1);
       emit(completeState);
    }
  }



}
