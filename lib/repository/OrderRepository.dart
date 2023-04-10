import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/EnterNumberProvider.dart';
import 'package:quickk/provider/OrderProvider.dart';


class OrderRepository{

  final Dio client;

  OrderProvider provider ;

  OrderRepository(this.client){
    provider = new OrderProvider(client);
  }


  Future<Response> fetchOrderList(BuildContext context ,String userId) => provider.fetchOrderList(context,userId);

  Future<Response> cancelOrder(BuildContext context ,String orderId,String cancelReason,String userId) => provider.cancelOrder(context,orderId,cancelReason,userId);
}