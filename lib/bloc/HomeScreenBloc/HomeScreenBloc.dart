import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/Utils/Validations/MobileNumber.dart';
import 'package:quickk/modal/CategoryData.dart';
import 'package:quickk/modal/OfferData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/modal/SliderData.dart';
import 'package:quickk/modal/UserData.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'HomeScreenEvent.dart';
part 'HomeScreenState.dart';

class HomeScreenBloc extends Bloc<HomeScreenEvent, HomeScreenState> {
  HomeScreenRepository repository;

  HomeScreenBloc(this.repository)
      : super(const HomeScreenInitialState(version: 0)) {
    on<GetCategoryList>(_handleGetCategoryList, transformer: sequential());
    on<HomeDataList>(_handleHomeDataList, transformer: sequential());
    on<HomeSliderList>(_handleHomeSliderList, transformer: sequential());
    on<GetUserData>(_handleGetUserData, transformer: sequential());
  }

  void _handleGetCategoryList(
      GetCategoryList event, Emitter<HomeScreenState> emit) async {
    Response serverAPIResponseDto =
        await repository.fetchCategoryList(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<CategoryData> categoryDataList =
          (serverAPIResponseDto.data["data"] as List)
              .map((itemWord) => CategoryData.fromJson(itemWord))
              .toList();
      HomeScreenCompleteState completeState = new HomeScreenCompleteState(
          context: event.context,
          version: state.version + 1,
          categoryDataList: categoryDataList);
      emit(completeState);
    } else {
      HomeScreenInitialState completeState = new HomeScreenInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleHomeDataList(
      HomeDataList event, Emitter<HomeScreenState> emit) async {
    Response serverAPIResponseDto =
        await repository.fetchHomeDataList(event.context, event.userId);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> topProductDataList =
          (serverAPIResponseDto.data["data"]["top"] as List)
              .map((itemWord) => ProductData.fromJson(itemWord))
              .toList();
      List<OfferData> offerDataList =
          (serverAPIResponseDto.data["data"]["offer"] as List)
              .map((itemWord) => OfferData.fromJson(itemWord))
              .toList();
      List<ProductData> recomProductDataList =
          (serverAPIResponseDto.data["data"]["recom"] as List)
              .map((itemWord) => ProductData.fromJson(itemWord))
              .toList();
      HomeDataListCompleteState completeState = new HomeDataListCompleteState(
          context: event.context,
          version: state.version + 1,
          topProductDataList: topProductDataList,
          offerDataList: offerDataList,
          recomProductDataList: recomProductDataList);
      emit(completeState);
    } else {
      HomeScreenInitialState completeState = new HomeScreenInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleHomeSliderList(
      HomeSliderList event, Emitter<HomeScreenState> emit) async {
    Response serverAPIResponseDto =
        await repository.fetchHomeSliderList(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<SliderData> sliderDataList =
          (serverAPIResponseDto.data["data"] as List)
              .map((itemWord) => SliderData.fromJson(itemWord))
              .toList();
      HomeSliderCompleteState completeState = new HomeSliderCompleteState(
          context: event.context,
          version: state.version + 1,
          sliderDataList: sliderDataList);
      emit(completeState);
    } else {
      HomeScreenInitialState completeState = new HomeScreenInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleGetUserData(
      GetUserData event, Emitter<HomeScreenState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Response serverAPIResponseDto =
        await repository.getUserData(event.context, event.userId);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      Map<String, dynamic> dataDto =
          serverAPIResponseDto.data as Map<String, dynamic>;
      UserData newData = UserData.fromJson(dataDto["user"]);
      UserDataService userDataService = getIt<UserDataService>();
      prefs.setString('userData', jsonEncode(newData));
      userDataService.setUserdata(newData);
      GetUserDataCompleteState completeState = new GetUserDataCompleteState(
          version: state.version + 1, userData: newData);
      emit(completeState);
    } else {
      HomeScreenState completeState =
          new HomeScreenState(version: state.version + 1);
      emit(completeState);
    }
  }
}
