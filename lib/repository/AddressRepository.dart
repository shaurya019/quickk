import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/AddressProvider.dart';
import 'package:quickk/provider/EnterNumberProvider.dart';


class AddressRepository{

  final Dio client;

  AddressProvider provider ;

  AddressRepository(this.client){
    provider = new AddressProvider(client);
  }


  Future<Response> saveAddress(BuildContext context ,String address1,String address2,String address3,String pincode,String latitude , String longitude,String userId) => provider.saveAddress(context,address1,address2,address3,pincode,latitude,longitude,userId);

  Future<Response> getAddressList(BuildContext context ,String userId) => provider.getAddressList(context,userId);

  Future<Response> setCurrentAddress(BuildContext context ,String addid,String userId) => provider.setCurrentAddress(context,addid,userId);
}