import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:quickk/provider/OTPVerificationProvider.dart';
import 'package:quickk/provider/ProductProvider.dart';
import 'package:quickk/provider/ProfileDetailProvider.dart';

class ProductRepository {
  final Dio client;

  ProductProvider provider;

  ProductRepository(this.client) {
    provider = new ProductProvider(client);
  }

  Future<Response> fetchProductList(
          BuildContext context, String categoryId, String userId) =>
      provider.fetchProductList(context, categoryId, userId);

  Future<Response> fetchProductdata(BuildContext context, String productId) =>
      provider.fetchProductdata(context, productId);

  Future<Response> addToCart(BuildContext context, String productId,
          String userId, String userType) =>
      provider.addToCart(context, productId, userId, userType);

  Future<Response> fetchAllProductList(BuildContext context, userId) =>
      provider.fetchAllProductList(context, userId);

  Future<Response> fetchCartList(BuildContext context, String userId) =>
      provider.fetchCartList(context, userId);

  Future<Response> addOrder(
          BuildContext context, String userId, String delieveryAddId) =>
      provider.addOrder(context, userId, delieveryAddId);

  Future<Response> deleteFromCart(BuildContext context, String cartId) =>
      provider.deleteFromCart(context, cartId);

  Future<Response> addtoWishlist(BuildContext context, String productId,
          String userId, String userType) =>
      provider.addtoWishlist(context, productId, userId, userType);

  Future<Response> fetchWishListList(BuildContext context, String userId) =>
      provider.fetchWishListList(context, userId);

  Future<Response> deleteWishListList(
          BuildContext context, String wishListid) =>
      provider.deleteWishListList(context, wishListid);

  Future<Response> editCartList(
          BuildContext context, String cartId, String userId, String qty) =>
      provider.editCartList(context, cartId, userId, qty);

  Future<Response> searchProduct(
          BuildContext context, String text, String userId) =>
      provider.searchProduct(context, text, userId);

  Future<Response> addPromoCode(BuildContext context, String userId,
          String promocode, String billamount) =>
      provider.addPromoCode(context, userId, promocode, billamount);
  Future<Response> Promolist(BuildContext context) => provider.Promolist(
        context,
      );
}
