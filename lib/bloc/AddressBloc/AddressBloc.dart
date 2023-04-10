import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/modal/LocationData.dart';
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'AddressEvent.dart';
part 'AddressState.dart';

class AddressBloc extends Bloc<AddressEvent, AddressState> {
  AddressRepository repository;

  AddressBloc(this.repository) : super(const AddressInitialState(version: 0)) {
    on<SaveAddressEvent>(_handleSaveAddressEvent, transformer: sequential());
    on<GetAddressList>(_handleGetAddressList, transformer: sequential());
    on<SetCurrentAddressEvent>(_handleSetCurrentAddressEvent,
        transformer: sequential());
  }

  void _handleSaveAddressEvent(
      SaveAddressEvent event, Emitter<AddressState> emit) async {
    AddressState currentState = state as AddressState;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.saveAddress(
        event.context,
        event.address1,
        event.address2,
        event.address2,
        event.pincode,
        event.latitude,
        event.longitude,
        event.userid);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        serverAPIResponseDto.data["status"].toString() == "200") {
      Map<String, dynamic> dataDto =
          serverAPIResponseDto.data as Map<String, dynamic>;
      if (dataDto["address"] != null && dataDto["address"].length > 0) {
        LocationData newData = LocationData.fromJson(dataDto["address"][0]);
        LocationDataService locationDataService = getIt<LocationDataService>();
        locationDataService.setLocationData(newData);
        prefs.setString('locationData', jsonEncode(newData));
      }
      AddressCompleteState completeState = new AddressCompleteState(
          context: event.context,
          version: state.version + 1,
          locationDataList: null);
      emit(completeState);
    }
  }

  void _handleGetAddressList(
      GetAddressList event, Emitter<AddressState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto =
        await repository.getAddressList(event.context, event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        serverAPIResponseDto.data["status"].toString() == "200") {
      List<LocationData> locationDataList =
          (serverAPIResponseDto.data["data"] as List)
              .map((itemWord) => LocationData.fromJson(itemWord))
              .toList();
      AddressCompleteState completeState = new AddressCompleteState(
          context: event.context,
          version: state.version + 1,
          locationDataList: locationDataList);
      emit(completeState);
    }
  }

  void _handleSetCurrentAddressEvent(
      SetCurrentAddressEvent event, Emitter<AddressState> emit) async {
    AddressState currentState = state as AddressState;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.setCurrentAddress(
        event.context, event.addid, event.userid);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        serverAPIResponseDto.data["status"].toString() == "200") {
      Map<String, dynamic> dataDto =
          serverAPIResponseDto.data as Map<String, dynamic>;
      LocationData newData = LocationData.fromJson(dataDto["data"][0]);
      LocationDataService locationDataService = getIt<LocationDataService>();
      locationDataService.setLocationData(newData);
      prefs.setString('locationData', jsonEncode(newData));
      SetAddressCompleteState completeState = new SetAddressCompleteState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }
}
