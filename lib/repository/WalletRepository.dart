import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/EnterNumberProvider.dart';
import 'package:quickk/provider/OrderProvider.dart';
import 'package:quickk/provider/WalletProvider.dart';


class WalletRepository{

  final Dio client;

  WalletProvider provider ;

  WalletRepository(this.client){
    provider = new WalletProvider(client);
  }


  Future<Response> fetchWalletList(BuildContext context ,String userId) => provider.fetchWalletList(context,userId);

}