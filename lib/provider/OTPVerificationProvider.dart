import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';




class OTPVerificationException implements Exception {

  OTPVerificationException(error){
    print(error);
  }
}

class OTPVerificationProvider {
  OTPVerificationProvider(this.client);

  final Dio client;

  String apiUrl = "";

  //Get Server Config
  Future<Response> verifyOTP(BuildContext context, String mobileNumber,String otpNumber) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.otpcheck;
    FormData data;

    data = FormData.fromMap({
       "mobile":mobileNumber,
       //"rtype":"0",
       "otp":otpNumber
    });

    try {
      Response response = await client.post(apiUrl,data: data);
      print("response===verifyOTP=>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }




}
