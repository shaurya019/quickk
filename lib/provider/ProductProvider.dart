import 'dart:collection';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductException implements Exception {
  ProductException(error) {
    print(error);
  }
}

class ProductProvider {
  ProductProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response> fetchProductList(
      BuildContext context, String categoryId, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.productListbycatid +
        categoryId +
        "?userid=" +
        userId;
    print("apiurl=====>>>" + apiUrl.toString());

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchProductdata(
      BuildContext context, String productId) async {
    UserDataService userDataService = getIt<UserDataService>();

    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.Productbyid +
        productId +
        "?userid=" +
        userDataService.userData.customerid;
    print("apiurl=====>>>" + apiUrl.toString());

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> addToCart(BuildContext context, String productId,
      String userId, String userType) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.addtocartlist +
        "productid=" +
        productId +
        "&userid=" +
        userId +
        "&usertype=" +
        userType;
    FormData data;

    data = FormData.fromMap(
        {"productid": productId, "userid": userId, "userType": userType});

    try {
      Response response = await client.post(apiUrl, data: data);
      print("response======>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchAllProductList(
      BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.ProductList + userId;

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchCartList(BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.cartlist + userId;
    print("apiUrl===cartlist==>>>" + apiUrl.toString());

    try {
      Response response = await client.get(apiUrl);
      print("response==cartlist==>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> addOrder(
      BuildContext context, String userId, String delieveryAddId) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.checkout +
        userId +
        "&deliveryaddid=" +
        delieveryAddId;

    print("apiUrl====userId=>>>" +
        apiUrl.toString() +
        "\t\t" +
        userId.toString());
    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> deleteFromCart(BuildContext context, String cartId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.deleteCarthList + cartId;
    print("apiUrl=====>>>" + apiUrl.toString());
    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> addtoWishlist(BuildContext context, String productId,
      String userId, String userType) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.addtowishlist +
        "productid=" +
        productId +
        "&userid=" +
        userId +
        "&usertype=" +
        userType;
    print("apiUrl=====>>>" + apiUrl.toString());

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> fetchWishListList(
      BuildContext context, String userId) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.WishList + userId;

    try {
      Response response = await client.get(apiUrl);
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> deleteWishListList(
      BuildContext context, String wishListid) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.DeleteWishList + wishListid;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> editCartList(
      BuildContext context, String cartId, String userId, String qty) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.editcart +
        "id=" +
        cartId +
        "&qty=" +
        qty;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> searchProduct(
      BuildContext context, String text, String userId) async {
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.search +
        text +
        "?userid=" +
        userId;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> Promolist(
    BuildContext context,
  ) async {
    UserDataService userDataService = getIt<UserDataService>();
    apiUrl = ApiConstants.BASE_URL +
        ApiConstants.promolist +
        userDataService.userData.customerid;

    try {
      Response response = await client.get(apiUrl);
      print("response====>>>prmolist" + response.toString() + 'promolist');
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> addPromoCode(BuildContext context, String userId,
      String promocode, String billamount) async {
    Map data = {
      "userid": userId,
      "promocode": promocode,
      "billamount": billamount,
    };

    apiUrl = ApiConstants.BASE_URL + ApiConstants.promouse;

    try {
      Response response = await client.post(apiUrl, data: jsonEncode(data));
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }
}
