import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';




class EnterNumberException implements Exception {

  EnterNumberException(error){
    print(error);
  }
}

class EnterNumberProvider {
  EnterNumberProvider(this.client);

  final Dio client;

  String apiUrl = "";


  Future<Response> sendOTP(BuildContext context, String mobileNumber) async {
    FormData data;

    data = FormData.fromMap({
      "mobile":mobileNumber,
      "rtype":"0",
    });

    apiUrl = ApiConstants.BASE_URL + ApiConstants.auth;

    try {
      Response response = await client.post(apiUrl,data: data);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }


}
