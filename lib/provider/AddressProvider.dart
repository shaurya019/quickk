import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';




class AddressException implements Exception {

  AddressException(error){
    print(error);
  }
}

class AddressProvider {
  AddressProvider(this.client);

  final Dio client;

  String apiUrl = "";


  Future<Response> saveAddress(BuildContext context ,String address1,String address2,String address3,String pincode,String latitude , String longitude, String userId) async {


    Map data = {
      "address1":address1,
      "address2": address2,
      "address3": address3,
      "pincode" : pincode,
      "latitude":latitude,
      "longitude": longitude,
      "userid":userId
    };

    print("jsonEncode(data)===>>>"+jsonEncode(data).toString());

    apiUrl = ApiConstants.BASE_URL + ApiConstants.saveaddress;

    try {
      Response response = await client.post(apiUrl,data: jsonEncode(data),options: Options(
        headers: {
          'Content-Type': 'application/json; charset=UTF-8'
        },
      ),);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> getAddressList(BuildContext context ,String userId) async {



    apiUrl = ApiConstants.BASE_URL + ApiConstants.addresslist+"userid="+userId;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> setCurrentAddress(BuildContext context ,String addid,String userId) async {



    apiUrl = ApiConstants.BASE_URL + ApiConstants.setaddress+addid+"&userid="+userId;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }
}
