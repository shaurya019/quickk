import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/modal/WishListData.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'bloc/ProductBloc/ProductBloc.dart';

class Wishlist extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProductBloc(ProductRepository(Dio())),
        child: WishlistStateful(),
      ),
    );
  }
}

class WishlistStateful extends StatefulWidget {


  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<WishlistStateful> {
  List<WishListData> wishlistDataList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(WishDatalist(context: context, userId: userDataService.userData.customerid));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: BlocListener<ProductBloc, ProductState>(
                listener: (context, state) {
                  if (state is WishListCompleteState) {
                    setState(() {
                      wishlistDataList = state.wishListDataList;
                    });
                  }
                  else if (state is DeleteFromWishListCompleteState) {
                    setState(() {
                      BlocProvider.of<ProductBloc>(context).add(WishDatalist(context: context, userId: userDataService.userData.customerid));
                    });
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: 500.w,
                        height: 1,
                        color: Colors.black26,
                      ),
                      Container(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                                child: Text("Wishlist", style: TextStyle(color: Colors.black, fontSize: 15.sp),)
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 500.w,
                        height: 1,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Expanded(
                        child: Container(
                          width: 300.w,
                          child: ListView.builder(
                              itemCount: wishlistDataList.length,
                              physics: AlwaysScrollableScrollPhysics(),
                              itemBuilder: (BuildContext context, int index) {
                                return InkWell(
                                  onTap: () {

                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 10.h),
                                    height: 100.h,
                                    width: 300.w,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Row(
                                                  children: [
                                                    Container(
                                                      height: 24.h,
                                                      width: 60.w,
                                                      decoration: BoxDecoration(
                                                          color: Colors.red,
                                                          borderRadius: BorderRadius.only(
                                                            topLeft: Radius.circular(10),
                                                            bottomRight: Radius.circular(20),
                                                          )),
                                                      child: Center(
                                                        child: Text(
                                                          "26% off",
                                                          style: TextStyle(color: Colors.white),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                            ),
                                            GestureDetector(
                                              onTap: (){
                                                BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(context: context,wishListId:wishlistDataList[index].id,productDataList: null,currentIndex: null));
                                              },
                                              child: Icon(Icons.favorite,color: Colors.redAccent,size: 30.sp,),
                                            ),
                                            SizedBox(width: 10,)
                                          ],
                                        ),
                                        Positioned(
                                            top: 24.h,
                                            left: 20.w,
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  child: Image.network(
                                                    ApiConstants.IMAGE_URL +
                                                        wishlistDataList[index]
                                                            .imgurl
                                                            .toString(),
                                                    height: 70.h,
                                                    width: 70.w,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Container(
                                                  height: 70.h,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        wishlistDataList[index]
                                                            .name
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontWeight: FontWeight.bold,
                                                            fontSize: 12.sp),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          /*Text(productDataList[index].name.toString(), style: TextStyle(
                                                      fontWeight: FontWeight.bold, fontSize: 12.sp,
                                                      color: Colors.black38
                                                  ),),*/
                                                          Text(
                                                            "Rs. " +
                                                                wishlistDataList[index]
                                                                    .b2bselprice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                FontWeight.bold,
                                                                fontSize: 12.sp),
                                                          ),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )),
                                       /* Positioned(
                                            left: 200.w,
                                            top: 60.h,
                                            child: GestureDetector(
                                                onTap: () {},
                                                child: (wishlistDataList[index]
                                                    .isProductAddToCart)
                                                    ? Container(
                                                  height: 30.h,
                                                  width: 80.w,
                                                  decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                                  child: Center(
                                                    child: Text(
                                                      "ADDED",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  ),
                                                )
                                                    : GestureDetector(
                                                  onTap: () {
                                                    BlocProvider
                                                        .of<ProductBloc>(
                                                        context)
                                                        .add(AddToCartEvent(
                                                        context: context,
                                                        productId:
                                                        productDataList[
                                                        index]
                                                            .productid
                                                            .toString(),
                                                        userId:
                                                        userDataService
                                                            .userData
                                                            .customerid,
                                                        userType:
                                                        userDataService
                                                            .userData
                                                            .usertype,
                                                        productDataList:
                                                        productDataList,
                                                        currentIndex: index));
                                                  },
                                                  child: Container(
                                                    height: 30.h,
                                                    width: 80.w,
                                                    decoration: BoxDecoration(
                                                        color: Colors.red,
                                                        borderRadius:
                                                        BorderRadius.circular(
                                                            10)),
                                                    child: Center(
                                                      child: Text(
                                                        "ADD",
                                                        style: TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                  ),
                                                ))),*/
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}
