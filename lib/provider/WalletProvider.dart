import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';




class WalletException implements Exception {

  WalletException(error){
    print(error);
  }
}

class WalletProvider {
  WalletProvider(this.client);

  final Dio client;

  String apiUrl = "";


  Future<Response> fetchWalletList(BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.walletreport+userId;
    print("apiUrl====>>>"+apiUrl.toString());
    try {
      Response response = await client.post(apiUrl);
      print("response=====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }


}
