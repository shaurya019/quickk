import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';




class OrderException implements Exception {

  OrderException(error){
    print(error);
  }
}

class OrderProvider {
  OrderProvider(this.client);

  final Dio client;

  String apiUrl = "";


  Future<Response> fetchOrderList(BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.orderlist+userId;
    try {
      Response response = await client.post(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }


  Future<Response> cancelOrder(BuildContext context ,String orderId,String cancelReason,String userId) async {

    apiUrl = ApiConstants.BASE_URL + ApiConstants.ordercancel+"?id="+orderId+"&reson="+cancelReason+"&userid="+userId;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>"+response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }


}
