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
import 'package:quickk/Utils/Validations/Email.dart';
import 'package:quickk/Utils/Validations/FirstName.dart';
import 'package:quickk/Utils/Validations/LastName.dart';
import 'package:quickk/Utils/Validations/MobileNumber.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/modal/PromoList.dart';
import 'package:quickk/modal/WishListData.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/repository/ProfileDetailRepository.dart';

part 'ProductEvent.dart';
part 'ProductState.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  ProductRepository repository;

  ProductBloc(this.repository) : super(const ProductInitialState(version: 0)) {
    on<FetchProductList>(_handleFetchProductList, transformer: sequential());
    on<FetchProductData>(_handleFetchProductData, transformer: sequential());
    on<AddToCartEvent>(_handleAddToCartEvent, transformer: sequential());
    on<FetchAllProductList>(_handleFetchAllProductList,
        transformer: sequential());
    on<FetchCartList>(_handleFetchCartList, transformer: sequential());
    on<AddOrder>(_handleAddOrder, transformer: sequential());
    on<DeleteFromCart>(_handleDeleteFromCart, transformer: sequential());
    on<AddtoWishlist>(_handleAddtoWishlist, transformer: sequential());
    on<WishDatalist>(_handleWishDatalist, transformer: sequential());
    on<DeleteFromWishDatalist>(_handleDeleteFromWishDatalist,
        transformer: sequential());
    on<EditCart>(_handleEditCart, transformer: sequential());
    on<SearchProduct>(_handleSearchProduct, transformer: sequential());
    on<AddPromoCode>(_handleAddPromoCode, transformer: sequential());
    on<PromoListdata>(_handlePromoList, transformer: sequential());
  }

  void _handleFetchProductList(
      FetchProductList event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.fetchProductList(
        event.context, event.categoryId, event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> productDataList =
          (serverAPIResponseDto.data["data"]["table"] as List)
              .map((itemWord) => ProductData.fromJson(itemWord))
              .toList();
      ProductCompleteState completeState = new ProductCompleteState(
          context: event.context,
          version: state.version + 1,
          productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleFetchProductData(
      FetchProductData event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto =
        await repository.fetchProductdata(event.context, event.productId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      ProductData productData;
      if (serverAPIResponseDto.data["data"] != null &&
          serverAPIResponseDto.data["data"].length > 0) {
        productData =
            ProductData.fromJson(serverAPIResponseDto.data["data"][0]);
      }
      ProductDataFetchState completeState = new ProductDataFetchState(
          context: event.context,
          version: state.version + 1,
          productData: productData);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleAddToCartEvent(
      AddToCartEvent event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.addToCart(
        event.context, event.productId, event.userId, event.userType);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> productDataList = event.productDataList;
      if (event.productDataList != null) {
        productDataList[event.currentIndex].cartlist =
            serverAPIResponseDto.data["data"]["id"].toString();
      }
      AddtoCartCompleteState completeState = new AddtoCartCompleteState(
          context: event.context,
          version: state.version + 1,
          productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleFetchAllProductList(
      FetchAllProductList event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto =
        await repository.fetchAllProductList(event.context, event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> productDataList =
          (serverAPIResponseDto.data["data"]["table"] as List)
              .map((itemWord) => ProductData.fromJson(itemWord))
              .toList();
      ProductCompleteState completeState = new ProductCompleteState(
          context: event.context,
          version: state.version + 1,
          productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleFetchCartList(
      FetchCartList event, Emitter<ProductState> emit) async {
    Response serverAPIResponseDto =
        await repository.fetchCartList(event.context, event.userId);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<CartData> cartDataList;
      if ((serverAPIResponseDto.data["data"] != null) &&
          serverAPIResponseDto.data["data1"] != null) {
        cartDataList = (serverAPIResponseDto.data["data"] as List)
            .map((itemWord) => CartData.fromJson(itemWord))
            .toList();
        CartDataCompleteState completeState = new CartDataCompleteState(
            context: event.context,
            version: state.version + 1,
            cartDataList: cartDataList,
            subtotal: serverAPIResponseDto.data["data1"]["subtotal"].toString(),
            Shipchrg: serverAPIResponseDto.data["data1"]["Shipchrg"].toString(),
            discount: serverAPIResponseDto.data["data1"]["discount"].toString(),
            total: serverAPIResponseDto.data["data1"]["total"].toString());
        emit(completeState);
      } else {
        CartDataCompleteState completeState = new CartDataCompleteState(
            context: event.context,
            version: state.version + 1,
            cartDataList: cartDataList);
        emit(completeState);
      }
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleAddOrder(AddOrder event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.addOrder(
        event.context, event.userId, event.delieveryAddId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      OrderCompleteState completeState = new OrderCompleteState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleDeleteFromCart(
      DeleteFromCart event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto =
        await repository.deleteFromCart(event.context, event.cartId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      DeleteFromCartCompleteState completeState =
          new DeleteFromCartCompleteState(
              context: event.context, version: state.version + 1);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleAddtoWishlist(
      AddtoWishlist event, Emitter<ProductState> emit) async {
    //DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto = await repository.addtoWishlist(
        event.context, event.productId, event.userId, event.userType);
    //DialogUtil.dismissProgressDialog(event.context);
    print("serverAPIResponseDto====>>>" + serverAPIResponseDto.toString());
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> productDataList = event.productDataList;
      productDataList[event.currentIndex].wishlist = event.productId.toString();
      AddtoWishListCompleteState completeState = new AddtoWishListCompleteState(
          context: event.context,
          version: state.version + 1,
          productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleWishDatalist(
      WishDatalist event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto =
        await repository.fetchWishListList(event.context, event.userId);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<WishListData> wishlistDataList =
          (serverAPIResponseDto.data["data"] as List)
              .map((itemWord) => WishListData.fromJson(itemWord))
              .toList();
      WishListCompleteState completeState = new WishListCompleteState(
          context: event.context,
          version: state.version + 1,
          wishListDataList: wishlistDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleDeleteFromWishDatalist(
      DeleteFromWishDatalist event, Emitter<ProductState> emit) async {
    //DialogUtil.showProgressDialog("",event.context);
    Response serverAPIResponseDto =
        await repository.deleteWishListList(event.context, event.wishListId);
    //DialogUtil.dismissProgressDialog(event.context);
    List<ProductData> productDataList;
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      if (event.productDataList != null) {
        productDataList = event.productDataList;
        productDataList[event.currentIndex].wishlist = null;
      }
      DeleteFromWishListCompleteState completeState =
          new DeleteFromWishListCompleteState(
              context: event.context,
              version: state.version + 1,
              productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleEditCart(EditCart event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.editCartList(
        event.context, event.cartId, event.userId, event.qty);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      EditCartListCompleteState completeState = new EditCartListCompleteState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleSearchProduct(
      SearchProduct event, Emitter<ProductState> emit) async {
    Response serverAPIResponseDto =
        await repository.searchProduct(event.context, event.text, event.userId);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<ProductData> productDataList =
          (serverAPIResponseDto.data["data"]["table"] as List)
              .map((itemWord) => ProductData.fromJson(itemWord))
              .toList();
      SearchedProductCompleteState completeState =
          new SearchedProductCompleteState(
              context: event.context,
              version: state.version + 1,
              productDataList: productDataList);
      emit(completeState);
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handleAddPromoCode(
      AddPromoCode event, Emitter<ProductState> emit) async {
    DialogUtil.showProgressDialog("", event.context);
    Response serverAPIResponseDto = await repository.addPromoCode(
        event.context, event.userId, event.promocode, event.billamount);
    DialogUtil.dismissProgressDialog(event.context);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      String discount = serverAPIResponseDto.data["discount"].toString();
      PromocodeCompleteState completeState = new PromocodeCompleteState(
          context: event.context,
          version: state.version + 1,
          discount: discount);
      emit(completeState);
    } else {
      DialogUtil.showInfoDialog("PromoCode",
          serverAPIResponseDto.data["messages"].toString(), event.context);
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }

  void _handlePromoList(PromoListdata event, Emitter<ProductState> emit) async {
    Response serverAPIResponseDto = await repository.Promolist(event.context);
    print(serverAPIResponseDto);
    if (serverAPIResponseDto != null &&
        (serverAPIResponseDto.data["status"].toString() == "200" ||
            serverAPIResponseDto.data["status"].toString() == "201")) {
      List<PromoList> promolist;
      if (serverAPIResponseDto.data["data"] != null) {
        promolist = (serverAPIResponseDto.data["data"] as List)
            .map((itemWord) => PromoList.fromJson(itemWord))
            .toList();
        print(promolist);
        PromoListCompleteState completeState = new PromoListCompleteState(
            context: event.context,
            version: state.version + 1,
            promolist: promolist);
        emit(completeState);
      } else {
        // PromoListCompleteState completeState = new PromoListCompleteState(
        //     context: event.context,
        //     version: state.version + 1,
        //     promolist: promolist);
        // emit(completeState);
      }
    } else {
      ProductInitialState completeState = new ProductInitialState(
          context: event.context, version: state.version + 1);
      emit(completeState);
    }
  }
}
