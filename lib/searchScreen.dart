import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/BottomNavigationWidget.dart';
import 'package:quickk/ProfileScreen.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DataNotAvailable.dart';
import 'package:quickk/bloc/ProductBloc/ProductBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/orderScreen.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:quickk/shopingCart.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProductBloc(ProductRepository(Dio())),
        child: SearchScreenStateful(),
      ),
    );
  }
}

class SearchScreenStateful extends StatefulWidget {
  @override
  _SearchScreenStatefulState createState() => _SearchScreenStatefulState();
}

class _SearchScreenStatefulState extends State<SearchScreenStateful> {
  List<ProductData> productDataList = List.empty(growable: true);
  List<ProductData> searchProductDataList = List.empty(growable: true);
  List<CartData> cartDataList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();
  int qty = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  double sellingPrice = 0.0;
  bool getData = false;
  double orignalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<ProductBloc>(context).add(FetchAllProductList(
        context: context, userId: userDataService.userData.customerid));
  }

  Future<bool> _willPopCallback() async {
    Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: BlocListener<ProductBloc, ProductState>(
            listener: (context, state) {
              if (state is ProductCompleteState) {
                setState(() {
                  productDataList = state.productDataList;
                  getData = true;
                });
              } else if (state is AddtoCartCompleteState) {
                setState(() {
                  productDataList = state.productDataList;
                  BlocProvider.of<ProductBloc>(context).add(FetchCartList(
                      context: context,
                      userId: userDataService.userData.customerid));
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
                BlocProvider.of<ProductBloc>(context).add(FetchAllProductList(
                    context: context,
                    userId: userDataService.userData.customerid));
              }
              if (state is CartDataCompleteState) {
                setState(() {
                  cartDataList = state.cartDataList;
                });
              }
            },
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: 55.h,
                      width: MediaQuery.of(context).size.width,
                      color: Colors.black12,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          InkWell(
                              onTap: () {
                                Get.to(HomeScreen());
                                //Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            height: 40.h,
                            width: 220.w,
                            padding: EdgeInsets.only(left: 20.w, right: 20.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border:
                                    Border.all(color: Colors.black26, width: 2),
                                color: Colors.white),
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
                                        FetchAllProductList(
                                            context: context,
                                            userId: userDataService
                                                .userData.customerid));
                                  }
                                },
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                          InkWell(
                              onTap: () {
                                //  Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.search,
                                size: 30,
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          GestureDetector(
                              // onTap: () {
                              //   //Navigator.push(context, MaterialPageRoute(builder: (Context)=>ShopingCart()));
                              //   Get.to(ShopingCart()).then((value) =>
                              //       BlocProvider.of<ProductBloc>(context).add(
                              //           FetchAllProductList(
                              //               context: context,
                              //               userId: userDataService
                              //                   .userData.customerid)));
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
                        ],
                      ),
                    ),
                    Container(
                      width: 500.w,
                      height: 1,
                      color: Colors.black26,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Container(
                        //width:300.w,
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: (getData == true)
                            ? (productDataList.length > 0)
                                ? GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            childAspectRatio: 0.75),
                                    shrinkWrap: true,
                                    itemCount: productDataList.length,
                                    itemBuilder: (BuildContext ctx, index) {
                                      sellingPrice = 0.0;
                                      orignalPrice = 0.0;
                                      if (userDataService.userData.usertype ==
                                          "1") {
                                        orignalPrice = double.parse(
                                            productDataList[index]
                                                .mrp
                                                .toString());
                                        //         *
                                        // int.parse(productDataList[index]
                                        //     .qty
                                        //     .toString());
                                        sellingPrice = double.parse(
                                            productDataList[index]
                                                .b2cselprice
                                                .toString());
                                        //          *
                                        // int.parse(productDataList[index]
                                        //     .qty
                                        //     .toString());
                                      } else if (userDataService
                                              .userData.usertype ==
                                          "2") {
                                        orignalPrice = double.parse(
                                            productDataList[index]
                                                .mrp
                                                .toString());
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
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(ProductDescription(
                                              productDataList[index]
                                                  .productid));
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              bottom: 10.h, right: 10.w),
                                          // height: 280.h,
                                          width: 140.w,
                                          decoration: BoxDecoration(
                                              color: Colors.black12,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            children: [
                                              Container(
                                                height: 90.h,
                                                child: Stack(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 0.w,
                                                                top: 0.h),
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .only(
                                                              topLeft: Radius
                                                                  .circular(
                                                                      15.w),
                                                              bottomLeft: Radius
                                                                  .circular(
                                                                      12.w),
                                                              topRight: Radius
                                                                  .circular(
                                                                      15.w),
                                                              bottomRight:
                                                                  Radius
                                                                      .circular(
                                                                          12.w),
                                                            ),
                                                            child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 3.w,
                                                                      right:
                                                                          3.w,
                                                                      top: 3.h),
                                                              child:
                                                                  Image.network(
                                                                ApiConstants
                                                                        .IMAGE_URL +
                                                                    productDataList[
                                                                            index]
                                                                        .imgurl,
                                                                height: 100.h,
                                                                width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width
                                                                    .w,
                                                                fit:
                                                                    BoxFit.fill,
                                                              ),
                                                            ))),
                                                    // Align(
                                                    //     alignment:
                                                    //         Alignment.topRight,
                                                    //     child: Padding(
                                                    //       padding:
                                                    //           EdgeInsets.only(
                                                    //               right: 2.w,
                                                    //               top: 2.h),
                                                    //       child: (productDataList[
                                                    //                           index]
                                                    //                       .wishlist !=
                                                    //                   null &&
                                                    //               productDataList[
                                                    //                           index]
                                                    //                       .wishlist !=
                                                    //                   "")
                                                    //           ? GestureDetector(
                                                    //               onTap: () {
                                                    //                 BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                                    //                     context:
                                                    //                         context,
                                                    //                     wishListId:
                                                    //                         productDataList[index]
                                                    //                             .wishlist,
                                                    //                     productDataList:
                                                    //                         productDataList,
                                                    //                     currentIndex:
                                                    //                         index));
                                                    //               },
                                                    //               child: Icon(
                                                    //                 Icons
                                                    //                     .favorite,
                                                    //                 color: Colors
                                                    //                     .redAccent,
                                                    //                 size: 30.sp,
                                                    //               ),
                                                    //             )
                                                    //           : GestureDetector(
                                                    //               onTap: () {
                                                    //                 BlocProvider.of<ProductBloc>(context).add(AddtoWishlist(
                                                    //                     context:
                                                    //                         context,
                                                    //                     productId:
                                                    //                         productDataList[index]
                                                    //                             .productid,
                                                    //                     userId: userDataService
                                                    //                         .userData
                                                    //                         .customerid,
                                                    //                     userType: userDataService
                                                    //                         .userData
                                                    //                         .usertype,
                                                    //                     productDataList:
                                                    //                         productDataList,
                                                    //                     currentIndex:
                                                    //                         index));
                                                    //               },
                                                    //               child: Icon(
                                                    //                 Icons
                                                    //                     .favorite_outline_rounded,
                                                    //                 color: Colors
                                                    //                     .redAccent,
                                                    //                 size: 30.sp,
                                                    //               ),
                                                    //             ),
                                                    //     )),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                // height: 100.h,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          child: Text(
                                                            productDataList[
                                                                    index]
                                                                .name,
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    12.sp),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "₹" +
                                                              sellingPrice
                                                                  .toString(),
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 5.h,
                                                        ),
                                                        Text(
                                                          "₹" +
                                                              orignalPrice
                                                                  .toString(),
                                                          style: TextStyle(
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 13.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 5.h,
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        GestureDetector(
                                                            onTap: () {},
                                                            child: (productDataList[index]
                                                                            .cartlist !=
                                                                        null &&
                                                                    productDataList[index]
                                                                            .cartlist !=
                                                                        "")
                                                                ? Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            if (int.parse(productDataList[index].qty) >
                                                                                0) {
                                                                              qty = int.parse(productDataList[index].qty);
                                                                              qty = qty - 1;
                                                                              BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: productDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                            } else {
                                                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item quantity can not lesser than 0.")));
                                                                              //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                            }
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              24.h,
                                                                          width:
                                                                              24.w,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "-",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.w,
                                                                      ),
                                                                      Container(
                                                                        height:
                                                                            24.h,
                                                                        width:
                                                                            24.w,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.white70,
                                                                            borderRadius: BorderRadius.circular(5),
                                                                            border: Border.all(color: Colors.black26, width: 1)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            productDataList[index].qty.toString(),
                                                                            style:
                                                                                TextStyle(color: Colors.black, fontSize: 18.sp),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      SizedBox(
                                                                        width:
                                                                            5.w,
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          setState(
                                                                              () {
                                                                            qty =
                                                                                int.parse(productDataList[index].qty);
                                                                            qty =
                                                                                qty + 1;
                                                                            BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                                context: context,
                                                                                cartId: productDataList[index].cartlist,
                                                                                userId: userDataService.userData.customerid,
                                                                                qty: qty.toString()));
                                                                          });
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          height:
                                                                              24.h,
                                                                          width:
                                                                              24.w,
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                Colors.black54,
                                                                            borderRadius:
                                                                                BorderRadius.circular(5),
                                                                          ),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              "+",
                                                                              style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                : GestureDetector(
                                                                    onTap: () {
                                                                      BlocProvider.of<ProductBloc>(context).add(AddToCartEvent(
                                                                          context:
                                                                              context,
                                                                          productId: productDataList[index]
                                                                              .productid
                                                                              .toString(),
                                                                          userId: userDataService
                                                                              .userData
                                                                              .customerid,
                                                                          userType: userDataService
                                                                              .userData
                                                                              .usertype,
                                                                          productDataList:
                                                                              productDataList,
                                                                          currentIndex:
                                                                              index));
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          30.h,
                                                                      width:
                                                                          80.w,
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .red,
                                                                          borderRadius:
                                                                              BorderRadius.circular(10)),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            Text(
                                                                          "ADD",
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                      height: 10.h,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    })
                                : DataNotAvailable.dataNotAvailable(
                                    "Data not found")
                            : SizedBox(),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                  ],
                ),
              ),
            ),
          )),
          bottomNavigationBar: BottomNavigationWidget(1)),
    );
  }
}
