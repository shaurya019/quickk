import 'dart:collection';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreenException implements Exception {
  HomeScreenException(error) {
    print(error);
  }
}

class HomeScreenProvider {
  HomeScreenProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response> fetchCategoryList(BuildContext context) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.CategoryList;

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchHomeDataList(
      BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.index +
        "?rtype=0&userid=" +
        userId;
    print("apiurl===>>" + apiUrl);

    try {
      Response response = await client.get(apiUrl);
      print("response===home=>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchHomeSliderList(BuildContext context) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.sliderlist;

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> getUserData(BuildContext context, String userid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    FormData data;
    data = FormData.fromMap({
      "id": userid,
      "fcm_token": prefs.getString("fcm_token").toString(),
    });

    apiUrl = ApiConstants.BASE_URL + "Account/userdetails";

    try {
      Response response = await client.post(apiUrl, data: data);
      print("response===kkk=>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  aboutus(BuildContext context) async {
    apiUrl = "https://quickk.co.in/Home/about";

    try {
      Response response = await client.get(apiUrl);
      return response.data;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> tc(BuildContext context) async {
    apiUrl = "https://quickk.co.in/home/tc";

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<dynamic> contactus(BuildContext context) async {
    apiUrl = "https://quickk.co.in/home/contact";

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }
}
