import 'package:dio/dio.dart';
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:dio/src/response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/modal/OrderData.dart';
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/repository/OrderRepository.dart';



part 'OrderEvent.dart';
part 'OrderState.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderRepository repository;


  OrderBloc(this.repository) : super(const OrderInitialState(version: 0)){
    on<OrderListEvent>(_handleOrderListEvent, transformer: sequential());
    on<CancelOrderEvent>(_handleCancelOrderEvent, transformer: sequential());
  }

  void _handleOrderListEvent(OrderListEvent event, Emitter<OrderState> emit) async{
    DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto = await repository.fetchOrderList(event.context,event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null && serverAPIResponseDto.data["status"].toString() == "200"){
      if(serverAPIResponseDto.data["data"] != null){
        List<OrderData> orderList = (serverAPIResponseDto.data["data"] as List).map((itemWord) => OrderData.fromJson(itemWord)).toList();
        OrderCompleteState completeState = new OrderCompleteState(context: event.context , version: state.version+1,orderList: orderList,fromCancelOrder: event.fromCancelOrder);
        emit(completeState);
      }
      else{
        OrderCompleteState completeState = new OrderCompleteState(context: event.context , version: state.version+1,orderList: null);
        emit(completeState);
      }
    }
  }


  void _handleCancelOrderEvent(CancelOrderEvent event, Emitter<OrderState> emit) async{

    DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto = await repository.cancelOrder(event.context,event.orderId,event.cancelReason,event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if(serverAPIResponseDto != null && serverAPIResponseDto.data["status"].toString() == "200"){
      if(serverAPIResponseDto.data["data"] != null){
        CancelOrderCompleteState completeState = new CancelOrderCompleteState(context: event.context , version: state.version+1);
        emit(completeState);
      }
      else{
        OrderCompleteState completeState = new OrderCompleteState(context: event.context , version: state.version+1,orderList: null);
        emit(completeState);
      }
    }
  }

}
