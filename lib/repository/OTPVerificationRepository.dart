import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/OTPVerificationProvider.dart';


class OTPVerificationRepository{

  final Dio client;

  OTPVerificationProvider provider ;

  OTPVerificationRepository(this.client){
    provider = new OTPVerificationProvider(client);
  }


  Future<Response> verifyOTP(BuildContext context ,String mobileNumber,String otpNumber) => provider.verifyOTP(context,mobileNumber,otpNumber);


}