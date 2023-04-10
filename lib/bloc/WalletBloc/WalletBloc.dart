import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/modal/OrderData.dart';
import 'package:quickk/modal/WalletData.dart';
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/repository/OrderRepository.dart';
import 'package:quickk/repository/WalletRepository.dart';



part 'WalletEvent.dart';
part 'WalletState.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  WalletRepository repository;


  WalletBloc(this.repository) : super(const WalletInitialState(version: 0)){
    on<WalletListEvent>(_handleWalletListEvent, transformer: sequential());
  }

  void _handleWalletListEvent(WalletListEvent event, Emitter<WalletState> emit) async{
    DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto = await repository.fetchWalletList(event.context,event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null && serverAPIResponseDto.data["status"].toString() == "200"){
      if(serverAPIResponseDto.data["data"] != null){
        List<WalletData> walletDataList = (serverAPIResponseDto.data["data"] as List).map((itemWord) => WalletData.fromJson(itemWord)).toList();
        String walletAmount = serverAPIResponseDto.data["Balance"].toString();
        WalletCompleteState completeState = new WalletCompleteState(context: event.context , version: state.version+1,walletrList: walletDataList,walletAmount:walletAmount);
        emit(completeState);
      }
      else{
        WalletCompleteState completeState = new WalletCompleteState(context: event.context , version: state.version+1,walletrList: null);
        emit(completeState);
      }
    }
  }




}
