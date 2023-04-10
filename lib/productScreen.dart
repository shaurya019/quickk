import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DataNotAvailable.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:quickk/shopingCart.dart';

import 'bloc/ProductBloc/ProductBloc.dart';

class ProductScreen extends StatelessWidget {
  String categoryId;

  ProductScreen(String _value) {
    categoryId = _value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProductBloc(ProductRepository(Dio())),
        child: ProductScreenStateful(categoryId),
      ),
    );
  }
}

class ProductScreenStateful extends StatefulWidget {
  String categoryId;

  ProductScreenStateful(String _value) {
    categoryId = _value;
  }

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreenStateful> {
  List<ProductData> productDataList = List.empty(growable: true);
  List<CartData> cartDataList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();
  List<ProductData> searchProductDataList = List.empty(growable: true);
  int qty = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double sellingPrice = 0.0;
  double orignalPrice = 0.0;
  bool getData = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<ProductBloc>(context).add(FetchProductList(
        context: context,
        categoryId: widget.categoryId,
        userId: userDataService.userData.customerid));
  }

  getdata() async {
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    // BlocProvider.of<ProductBloc>(context).add(FetchProductList(
    //     context: context,
    //     categoryId: widget.categoryId,
    //     userId: userDataService.userData.customerid));
  }

  Future<bool> _willPopCallback() async {
    Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: SafeArea(
          child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is CartDataCompleteState) {
              setState(() {
                cartDataList = state.cartDataList;
                print(cartDataList.length);
              });
            }
            if (state is ProductCompleteState) {
              setState(() {
                productDataList = state.productDataList;
                getData = true;
              });
            } else if (state is AddtoCartCompleteState) {
              setState(() {
                productDataList = state.productDataList;
              });
            } else if (state is AddtoWishListCompleteState) {
              setState(() {
                productDataList = state.productDataList;
              });
            } else if (state is DeleteFromWishListCompleteState) {
              setState(() {
                productDataList = state.productDataList;
              });
            } else if (state is SearchedProductCompleteState) {
              setState(() {
                productDataList = state.productDataList;
              });
            } else if (state is EditCartListCompleteState) {
              BlocProvider.of<ProductBloc>(context).add(FetchProductList(
                  context: context,
                  categoryId: widget.categoryId,
                  userId: userDataService.userData.customerid));
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
                  height: 60.h,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(HomeScreen());
                          },
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                          )),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: Container(
                        height: 40.h,
                        //width: 300.w,
                        padding: EdgeInsets.only(left: 20.w, right: 20.w),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border:
                                Border.all(color: Colors.black26, width: 2)),
                        child: Center(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: "Search.......",
                              hintMaxLines: 2,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent),
                              ),
                            ),
                            onChanged: (value) {
                              if (value != null && value != "") {
                                BlocProvider.of<ProductBloc>(context).add(
                                    SearchProduct(
                                        context: context,
                                        text: value,
                                        userId: userDataService
                                            .userData.customerid));
                              } else {
                                BlocProvider.of<ProductBloc>(context).add(
                                    FetchProductList(
                                        context: context,
                                        categoryId: widget.categoryId,
                                        userId: userDataService
                                            .userData.customerid));
                              }
                            },
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10.w,
                      ),
                      GestureDetector(
                          // onTap: () {
                          //   Get.to(ShopingCart()).then((value) => getdata());
                          // },
                          child: Badge(
                            badgeContent: (cartDataList != null)
                                ? Text(
                                    cartDataList.length.toString(),
                                    style: TextStyle(fontSize: 10.sp),
                                  )
                                : Text(
                                    "0",
                                    style: TextStyle(fontSize: 10.sp),
                                  ),
                            child: Icon(
                              Icons.shopping_cart,
                              color: Colors.green,
                              size: 30,
                            ),
                          )),
                      SizedBox(
                        width: 10.w,
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
                    margin: EdgeInsets.only(top: 5.h),
                    child: (getData == true)
                        ? (productDataList.length > 0)
                            ? ListView.builder(
                                itemCount: productDataList.length,
                                physics: AlwaysScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  sellingPrice = 0.0;
                                  if (userDataService.userData.usertype ==
                                      "1") {
                                    sellingPrice = double.parse(
                                        productDataList[index]
                                            .b2cselprice
                                            .toString());
                                    //         *
                                    // int.parse(productDataList[index]
                                    //     .qty
                                    //     .toString());
                                    orignalPrice = double.parse(
                                        productDataList[index].mrp.toString());
                                    //         *
                                    // int.parse(productDataList[index]
                                    //     .qty
                                    //     .toString());
                                  } else if (userDataService
                                          .userData.usertype ==
                                      "2") {
                                    orignalPrice = double.parse(
                                        productDataList[index].mrp.toString());
                                    //          *
                                    // int.parse(productDataList[index]
                                    //     .qty
                                    //     .toString());
                                    sellingPrice = double.parse(
                                        productDataList[index]
                                            .b2bselprice
                                            .toString());
                                    //          *
                                    // int.parse(productDataList[index]
                                    //     .qty
                                    //     .toString());
                                  }
                                  return InkWell(
                                    onTap: () {
                                      Get.to(ProductDescription(
                                          productDataList[index].productid));
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 15.h),
                                      height: 92.h,
                                      width: 300.w,
                                      decoration: BoxDecoration(
                                          color: Colors.black12,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 3.w,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(top: 3.h),
                                            child: ClipRRect(
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(7),
                                                bottomLeft: Radius.circular(7),
                                                topRight: Radius.circular(7),
                                                bottomRight: Radius.circular(7),
                                              ),
                                              child: Image.network(
                                                ApiConstants.IMAGE_URL +
                                                    productDataList[index]
                                                        .imgurl
                                                        .toString(),
                                                height: 87.h,
                                                width: 90.w,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Expanded(
                                              child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 15.h,
                                              ),
                                              Text(
                                                productDataList[index]
                                                    .name
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12.sp),
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "₹" +
                                                          "${sellingPrice.toString()}",
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13.sp),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5.h,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      "₹" +
                                                          orignalPrice
                                                              .toString(),
                                                      style: TextStyle(
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 13.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          )),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              // Expanded(
                                              //     child: Column(
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment.start,
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment.start,
                                              //   children: [
                                              //     Row(
                                              //       mainAxisAlignment:
                                              //           MainAxisAlignment.end,
                                              //       crossAxisAlignment:
                                              //           CrossAxisAlignment.end,
                                              //       children: [
                                              //         Padding(
                                              //           padding:
                                              //               EdgeInsets.only(
                                              //                   right: 0.w,
                                              //                   top: 5.h),
                                              //           child: (productDataList[
                                              //                               index]
                                              //                           .wishlist !=
                                              //                       null &&
                                              //                   productDataList[
                                              //                               index]
                                              //                           .wishlist !=
                                              //                       "")
                                              //               ? GestureDetector(
                                              //                   onTap: () {
                                              //                     BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                              //                         context:
                                              //                             context,
                                              //                         wishListId:
                                              //                             productDataList[index]
                                              //                                 .wishlist,
                                              //                         productDataList:
                                              //                             productDataList,
                                              //                         currentIndex:
                                              //                             index));
                                              //                   },
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .favorite,
                                              //                     color: Colors
                                              //                         .redAccent,
                                              //                     size: 30.sp,
                                              //                   ),
                                              //                 )
                                              //               : GestureDetector(
                                              //                   onTap: () {
                                              //                     BlocProvider.of<ProductBloc>(context).add(AddtoWishlist(
                                              //                         context:
                                              //                             context,
                                              //                         productId:
                                              //                             productDataList[index]
                                              //                                 .productid,
                                              //                         userId: userDataService
                                              //                             .userData
                                              //                             .customerid,
                                              //                         userType: userDataService
                                              //                             .userData
                                              //                             .usertype,
                                              //                         productDataList:
                                              //                             productDataList,
                                              //                         currentIndex:
                                              //                             index));
                                              //                   },
                                              //                   child: Icon(
                                              //                     Icons
                                              //                         .favorite_outline_rounded,
                                              //                     color: Colors
                                              //                         .redAccent,
                                              //                     size: 30.sp,
                                              //                   ),
                                              //                 ),
                                              //         ),
                                              //         SizedBox(
                                              //           width: 10,
                                              //         ),
                                              //       ],
                                              //     )
                                              //   ],
                                              // )),
                                              (productDataList[index]
                                                              .cartlist !=
                                                          null &&
                                                      productDataList[index]
                                                              .cartlist !=
                                                          "")
                                                  ? Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              if (int.parse(
                                                                      productDataList[
                                                                              index]
                                                                          .qty) >
                                                                  0) {
                                                                qty = int.parse(
                                                                    productDataList[
                                                                            index]
                                                                        .qty);
                                                                qty = qty - 1;
                                                                BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                    context:
                                                                        context,
                                                                    cartId: productDataList[
                                                                            index]
                                                                        .cartlist,
                                                                    userId: userDataService
                                                                        .userData
                                                                        .customerid,
                                                                    qty: qty
                                                                        .toString()));
                                                              } else {
                                                                ScaffoldMessenger.of(
                                                                        context)
                                                                    .showSnackBar(SnackBar(
                                                                        content:
                                                                            Text("Item quantity can not lesser than 0.")));
                                                                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                              }
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 24.h,
                                                            width: 24.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors.red,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "-",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Container(
                                                          height: 24.h,
                                                          width: 24.w,
                                                          decoration: BoxDecoration(
                                                              color: Colors
                                                                  .white70,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                              border: Border.all(
                                                                  color: Colors
                                                                      .black26,
                                                                  width: 1)),
                                                          child: Center(
                                                            child: Text(
                                                              productDataList[
                                                                      index]
                                                                  .qty
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      18.sp),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              qty = int.parse(
                                                                  productDataList[
                                                                          index]
                                                                      .qty);
                                                              qty = qty + 1;
                                                              BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                  context:
                                                                      context,
                                                                  cartId: productDataList[
                                                                          index]
                                                                      .cartlist,
                                                                  userId: userDataService
                                                                      .userData
                                                                      .customerid,
                                                                  qty: qty
                                                                      .toString()));
                                                            });
                                                          },
                                                          child: Container(
                                                            height: 24.h,
                                                            width: 24.w,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black54,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          5),
                                                            ),
                                                            child: Center(
                                                              child: Text(
                                                                "+",
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20.sp),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10.w,
                                                        ),
                                                      ],
                                                    )
                                                  : GestureDetector(
                                                      onTap: () {
                                                        BlocProvider.of<
                                                                    ProductBloc>(
                                                                context)
                                                            .add(AddToCartEvent(
                                                                context:
                                                                    context,
                                                                productId: productDataList[
                                                                        index]
                                                                    .productid
                                                                    .toString(),
                                                                userId: userDataService
                                                                    .userData
                                                                    .customerid,
                                                                userType:
                                                                    userDataService
                                                                        .userData
                                                                        .usertype,
                                                                productDataList:
                                                                    productDataList,
                                                                currentIndex:
                                                                    index));
                                                        // Get.to(ShopingCart())
                                                        //     .then((value) =>
                                                        //         getdata());
                                                      },
                                                      child: Container(
                                                        height: 30.h,
                                                        width: 80.w,
                                                        margin: EdgeInsets.only(
                                                            bottom: 10.h,
                                                            right: 10.w),
                                                        decoration: BoxDecoration(
                                                            color: Colors.red,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10)),
                                                        child: Center(
                                                          child: Text(
                                                            "ADD",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                })
                            : DataNotAvailable.dataNotAvailable(
                                "Data not found")
                        : SizedBox(),
                  ),
                )
              ],
            ),
          ),
        )),
      )),
    );
  }
}
