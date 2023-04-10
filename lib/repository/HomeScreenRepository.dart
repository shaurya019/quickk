import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/HomeScreenProvider.dart';
import 'package:quickk/provider/ProductProvider.dart';

class HomeScreenRepository {
  final Dio client;

  HomeScreenProvider provider;

  HomeScreenRepository(this.client) {
    provider = new HomeScreenProvider(client);
  }

  Future<Response> fetchCategoryList(BuildContext context) =>
      provider.fetchCategoryList(context);

  Future<Response> fetchHomeDataList(BuildContext context, String userId) =>
      provider.fetchHomeDataList(context, userId);

  Future<Response> fetchHomeSliderList(BuildContext context) =>
      provider.fetchHomeSliderList(context);

  Future<Response> getUserData(BuildContext context, String userid) =>
      provider.getUserData(context, userid);

  Future<Response> getaboutData(BuildContext context) =>
      provider.aboutus(context);
}
