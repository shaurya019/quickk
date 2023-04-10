import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/bloc/HomeScreenBloc/HomeScreenBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/OfferData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/productScreen.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'bloc/ProductBloc/ProductBloc.dart';

class CategoriesToExplore extends StatelessWidget {
  String categoryName;

  CategoriesToExplore(String _categoryName) {
    categoryName = _categoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => HomeScreenBloc(HomeScreenRepository(Dio())),
        child: CategoriesToExploreStateful(categoryName),
      ),
    );
  }
}

class CategoriesToExploreStateful extends StatefulWidget {
  String categoryName;

  CategoriesToExploreStateful(String _categoryName) {
    categoryName = _categoryName;
  }

  @override
  _CategoriesToExploreState createState() => _CategoriesToExploreState();
}

class _CategoriesToExploreState extends State<CategoriesToExploreStateful> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<OfferData> offerDataList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();
  List<ProductData> topProductDataList = List.empty(growable: true);
  List<ProductData> recomProductDataList = List.empty(growable: true);
  double sellingPrice = 0.0;
  int qty = 0;
  double orignalPrice = 0.0;
  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(
        context: context, userId: userDataService.userData.customerid));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
          child: BlocListener<HomeScreenBloc, HomeScreenState>(
        listener: (context, state) {
          if (state is HomeDataListCompleteState) {
            setState(() {
              if (widget.categoryName == "offer") {
                offerDataList = state.offerDataList;
              } else if (widget.categoryName == "newArrivals") {
                topProductDataList = state.topProductDataList;
              } else if (widget.categoryName == "morepick") {
                recomProductDataList = state.recomProductDataList;
              }
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
                    (widget.categoryName == "offer")
                        ? Text(
                            "Offers",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                    (widget.categoryName == "newArrivals")
                        ? Text(
                            "New Arrivals",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox(),
                    (widget.categoryName == "morepick")
                        ? Text(
                            "More Top Picks for you",
                            style: TextStyle(
                                color: ColorConstants.primaryColor,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold),
                          )
                        : SizedBox()
                    /*Container(
                              height: 40.h,
                              width: 300.w,
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black26, width: 2)),
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search.......",
                                    hintMaxLines: 2,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if(value != null && value != ""){
                                      BlocProvider.of<ProductBloc>(context).add(SearchProduct(context: context, text: value,userId: userDataService.userData.customerid));
                                    }
                                    else{
                                      BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(context: context));
                                    }
                                  },
                                ),
                              ),
                            )*/
                  ],
                ),
              ),
              Container(
                width: 500.w,
                height: 1,
                color: Colors.black26,
              ),
              SizedBox(
                height: 0.h,
              ),
              (widget.categoryName == "offer")
                  ? Expanded(
                      child: Container(
                          width: 300.w,
                          margin: EdgeInsets.only(top: 5.h),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 4 / 4),
                              shrinkWrap: true,
                              itemCount: offerDataList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(ProductScreen(offerDataList[index]
                                        .categoryid
                                        .toString()));
                                  },
                                  child: Container(
                                      width:
                                          MediaQuery.of(context).size.width.w /
                                              3.2.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border.all(
                                            color: Colors.black12,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      margin: EdgeInsets.only(
                                          right: 10.w, top: 10.h),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                        child: Image.network(
                                            ApiConstants.IMAGE_URL +
                                                offerDataList[index].imgurl,
                                            fit: BoxFit.fill,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height
                                                .h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width
                                                .w),
                                      )),
                                );
                              })),
                    )
                  : SizedBox(),
              (widget.categoryName == "newArrivals")
                  ? Expanded(
                      child: Container(
                          width: 330.w,
                          margin: EdgeInsets.only(top: 15.h),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3.0),
                              shrinkWrap: true,
                              itemCount: topProductDataList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                sellingPrice = 0.0;
                                orignalPrice = 0.0;
                                print(topProductDataList[index].mrp.toString() +
                                    'mrp');
                                if (userDataService.userData.usertype == "1") {
                                  orignalPrice = double.parse(
                                          topProductDataList[index]
                                              .mrp
                                              .toString()) *
                                      int.parse(topProductDataList[index]
                                          .qty
                                          .toString());
                                  // print(
                                  //     orignalPrice.toString() + 'mmm');
                                  sellingPrice = double.parse(
                                          topProductDataList[index]
                                              .b2cselprice
                                              .toString()) *
                                      int.parse(topProductDataList[index]
                                          .qty
                                          .toString());
                                } else if (userDataService.userData.usertype ==
                                    "2") {
                                  orignalPrice = double.parse(
                                          topProductDataList[index]
                                              .mrp
                                              .toString()) *
                                      int.parse(topProductDataList[index]
                                          .qty
                                          .toString());
                                  print(orignalPrice.toString() + 'mmm');
                                  sellingPrice = double.parse(
                                          topProductDataList[index]
                                              .b2bselprice
                                              .toString()) *
                                      int.parse(topProductDataList[index]
                                          .qty
                                          .toString());
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(ProductDescription(
                                        topProductDataList[index].productid));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        bottom: 10.h, right: 10.w),
                                    //height: 280.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100.h,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 0.w, top: 0.h),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                15.w),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.w),
                                                        topRight:
                                                            Radius.circular(
                                                                15.w),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12.w),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 3.w,
                                                                right: 3.w,
                                                                top: 3.h),
                                                        child: Image.network(
                                                          ApiConstants
                                                                  .IMAGE_URL +
                                                              topProductDataList[
                                                                      index]
                                                                  .imgurl,
                                                          height: 100.h,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width
                                                              .w,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ))),
                                              // Align(
                                              //     alignment: Alignment.topRight,
                                              //     child: Padding(
                                              //       padding: EdgeInsets.only(
                                              //           right: 2.w, top: 2.h),
                                              //       child: (topProductDataList[
                                              //                           index]
                                              //                       .wishlist !=
                                              //                   null &&
                                              //               topProductDataList[
                                              //                           index]
                                              //                       .wishlist !=
                                              //                   "")
                                              //           ? GestureDetector(
                                              //               onTap: () {
                                              //                 BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                              //                     context:
                                              //                         context,
                                              //                     wishListId: topProductDataList[
                                              //                             index]
                                              //                         .wishlist,
                                              //                     productDataList:
                                              //                         topProductDataList,
                                              //                     currentIndex:
                                              //                         index));
                                              //               },
                                              //               child: Icon(
                                              //                 Icons.favorite,
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
                                              //                     productId: topProductDataList[
                                              //                             index]
                                              //                         .productid,
                                              //                     userId: userDataService
                                              //                         .userData
                                              //                         .customerid,
                                              //                     userType: userDataService
                                              //                         .userData
                                              //                         .usertype,
                                              //                     productDataList:
                                              //                         topProductDataList,
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
                                          // color: Colors.white,
                                          height: 100.h,
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
                                                      topProductDataList[index]
                                                          .name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      maxLines: 3,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),

                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "₹" +
                                                        sellingPrice.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.h,
                                                  ),
                                                  Text(
                                                    "₹" +
                                                        orignalPrice.toString(),
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {},
                                                      child: (topProductDataList[
                                                                          index]
                                                                      .cartlist !=
                                                                  null &&
                                                              topProductDataList[
                                                                          index]
                                                                      .cartlist !=
                                                                  "")
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (int.parse(
                                                                              topProductDataList[index].qty) >
                                                                          0) {
                                                                        qty = int.parse(
                                                                            topProductDataList[index].qty);
                                                                        qty = qty -
                                                                            1;
                                                                        BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                            context:
                                                                                context,
                                                                            cartId:
                                                                                topProductDataList[index].cartlist,
                                                                            userId: userDataService.userData.customerid,
                                                                            qty: qty.toString()));
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Item quantity can not lesser than 0.")));
                                                                        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        24.h,
                                                                    width: 24.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "-",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20.sp),
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
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black26,
                                                                          width:
                                                                              1)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      topProductDataList[
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
                                                                    setState(
                                                                        () {
                                                                      qty = int.parse(
                                                                          topProductDataList[index]
                                                                              .qty);
                                                                      qty =
                                                                          qty +
                                                                              1;
                                                                      BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                          context:
                                                                              context,
                                                                          cartId: topProductDataList[index]
                                                                              .cartlist,
                                                                          userId: userDataService
                                                                              .userData
                                                                              .customerid,
                                                                          qty: qty
                                                                              .toString()));
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        24.h,
                                                                    width: 24.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black54,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "+",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20.sp),
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
                                                                    productId: topProductDataList[
                                                                            index]
                                                                        .productid
                                                                        .toString(),
                                                                    userId: userDataService
                                                                        .userData
                                                                        .customerid,
                                                                    userType: userDataService
                                                                        .userData
                                                                        .usertype,
                                                                    productDataList:
                                                                        topProductDataList,
                                                                    currentIndex:
                                                                        index));
                                                              },
                                                              child: Container(
                                                                height: 30.h,
                                                                width: 80.w,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                            )),
                                                ],
                                              ),

                                              // SizedBox(
                                              //   height: 5.h,
                                              // ),
                                              // Row(
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment
                                              //           .center,
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .center,
                                              //   children: [
                                              //     Text(
                                              //       "₹" +
                                              //           sellingPrice
                                              //               .toString(),
                                              //       style: TextStyle(
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .bold,
                                              //           fontSize:
                                              //               14.sp),
                                              //     ),
                                              //   ],
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    )
                  : SizedBox(),
              (widget.categoryName == "morepick")
                  ? Expanded(
                      child: Container(
                          width: 330.w,
                          margin: EdgeInsets.only(top: 15.h),
                          child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 2 / 3.0),
                              shrinkWrap: true,
                              itemCount: recomProductDataList.length,
                              itemBuilder: (BuildContext ctx, index) {
                                sellingPrice = 0.0;
                                orignalPrice = 0.0;
                                if (userDataService.userData.usertype == "1") {
                                  orignalPrice = double.parse(
                                          recomProductDataList[index]
                                              .mrp
                                              .toString()) *
                                      int.parse(recomProductDataList[index]
                                          .qty
                                          .toString());
                                  sellingPrice = double.parse(
                                          recomProductDataList[index]
                                              .b2cselprice
                                              .toString()) *
                                      int.parse(recomProductDataList[index]
                                          .qty
                                          .toString());
                                } else if (userDataService.userData.usertype ==
                                    "2") {
                                  orignalPrice = double.parse(
                                          recomProductDataList[index]
                                              .mrp
                                              .toString()) *
                                      int.parse(recomProductDataList[index]
                                          .qty
                                          .toString());
                                  sellingPrice = double.parse(
                                          recomProductDataList[index]
                                              .b2bselprice
                                              .toString()) *
                                      int.parse(recomProductDataList[index]
                                          .qty
                                          .toString());
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Get.to(ProductDescription(
                                        recomProductDataList[index].productid));
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(
                                        bottom: 5.h, right: 10.w),
                                    //height: 280.h,
                                    width: 150.w,
                                    decoration: BoxDecoration(
                                        color: Colors.black12,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Container(
                                          height: 100.h,
                                          child: Stack(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 0.w, top: 0.h),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(
                                                                15.w),
                                                        bottomLeft:
                                                            Radius.circular(
                                                                12.w),
                                                        topRight:
                                                            Radius.circular(
                                                                15.w),
                                                        bottomRight:
                                                            Radius.circular(
                                                                12.w),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 3.w,
                                                                right: 3.w,
                                                                top: 3.h),
                                                        child: Image.network(
                                                          ApiConstants
                                                                  .IMAGE_URL +
                                                              recomProductDataList[
                                                                      index]
                                                                  .imgurl,
                                                          height: 100.h,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width
                                                              .w,
                                                          fit: BoxFit.fill,
                                                        ),
                                                      ))),
                                              // Align(
                                              //     alignment: Alignment.topRight,
                                              //     child: Padding(
                                              //       padding: EdgeInsets.only(
                                              //           right: 2.w, top: 2.h),
                                              //       child: (recomProductDataList[
                                              //                           index]
                                              //                       .wishlist !=
                                              //                   null &&
                                              //               recomProductDataList[
                                              //                           index]
                                              //                       .wishlist !=
                                              //                   "")
                                              //           ? GestureDetector(
                                              //               onTap: () {
                                              //                 BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                              //                     context:
                                              //                         context,
                                              //                     wishListId: recomProductDataList[
                                              //                             index]
                                              //                         .wishlist,
                                              //                     productDataList:
                                              //                         recomProductDataList,
                                              //                     currentIndex:
                                              //                         index));
                                              //               },
                                              //               child: Icon(
                                              //                 Icons.favorite,
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
                                              //                     productId: recomProductDataList[
                                              //                             index]
                                              //                         .productid,
                                              //                     userId: userDataService
                                              //                         .userData
                                              //                         .customerid,
                                              //                     userType: userDataService
                                              //                         .userData
                                              //                         .usertype,
                                              //                     productDataList:
                                              //                         recomProductDataList,
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
                                          height: 100.h,
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
                                                      recomProductDataList[
                                                              index]
                                                          .name,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12.sp),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 10.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "₹" +
                                                        sellingPrice.toString(),
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 15.sp),
                                                  ),
                                                  SizedBox(
                                                    width: 5.h,
                                                  ),
                                                  Text(
                                                    "₹" +
                                                        orignalPrice.toString(),
                                                    style: TextStyle(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 13.sp),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(
                                                height: 5.h,
                                              ),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                      onTap: () {},
                                                      child: (recomProductDataList[
                                                                          index]
                                                                      .cartlist !=
                                                                  null &&
                                                              recomProductDataList[
                                                                          index]
                                                                      .cartlist !=
                                                                  "")
                                                          ? Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(
                                                                        () {
                                                                      if (int.parse(
                                                                              recomProductDataList[index].qty) >
                                                                          0) {
                                                                        qty = int.parse(
                                                                            recomProductDataList[index].qty);
                                                                        qty = qty -
                                                                            1;
                                                                        BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                            context:
                                                                                context,
                                                                            cartId:
                                                                                recomProductDataList[index].cartlist,
                                                                            userId: userDataService.userData.customerid,
                                                                            qty: qty.toString()));
                                                                      } else {
                                                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                                            content:
                                                                                Text("Item quantity can not lesser than 0.")));
                                                                        //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                      }
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        24.h,
                                                                    width: 24.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .red,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "-",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20.sp),
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
                                                                          BorderRadius.circular(
                                                                              5),
                                                                      border: Border.all(
                                                                          color: Colors
                                                                              .black26,
                                                                          width:
                                                                              1)),
                                                                  child: Center(
                                                                    child: Text(
                                                                      recomProductDataList[
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
                                                                    setState(
                                                                        () {
                                                                      qty = int.parse(
                                                                          recomProductDataList[index]
                                                                              .qty);
                                                                      qty =
                                                                          qty +
                                                                              1;
                                                                      BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                          context:
                                                                              context,
                                                                          cartId: recomProductDataList[index]
                                                                              .cartlist,
                                                                          userId: userDataService
                                                                              .userData
                                                                              .customerid,
                                                                          qty: qty
                                                                              .toString()));
                                                                    });
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height:
                                                                        24.h,
                                                                    width: 24.w,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .black54,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              5),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "+",
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 20.sp),
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
                                                                    productId: recomProductDataList[
                                                                            index]
                                                                        .productid
                                                                        .toString(),
                                                                    userId: userDataService
                                                                        .userData
                                                                        .customerid,
                                                                    userType: userDataService
                                                                        .userData
                                                                        .usertype,
                                                                    productDataList:
                                                                        recomProductDataList,
                                                                    currentIndex:
                                                                        index));
                                                              },
                                                              child: Container(
                                                                height: 30.h,
                                                                width: 80.w,
                                                                decoration: BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
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
                                                            )),
                                                ],
                                              ),

                                              // Row(
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment
                                              //           .center,
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .center,
                                              //   children: [
                                              //     Text(
                                              //       "₹" +
                                              //           orignalPrice
                                              //               .toString(),
                                              //       style: TextStyle(
                                              //           decoration:
                                              //               TextDecoration
                                              //                   .lineThrough,
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .bold,
                                              //           fontSize:
                                              //               12.sp),
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(
                                              //   height: 5.h,
                                              // ),
                                              // Row(
                                              //   crossAxisAlignment:
                                              //       CrossAxisAlignment
                                              //           .center,
                                              //   mainAxisAlignment:
                                              //       MainAxisAlignment
                                              //           .center,
                                              //   children: [
                                              //     Text(
                                              //       "₹" +
                                              //           sellingPrice
                                              //               .toString(),
                                              //       style: TextStyle(
                                              //           fontWeight:
                                              //               FontWeight
                                              //                   .bold,
                                              //           fontSize:
                                              //               14.sp),
                                              //     ),
                                              //   ],
                                              // ),
                                              // SizedBox(
                                              //   height: 5.h,
                                              // ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              })),
                    )
                  : SizedBox()
            ],
          ),
        ),
      )),
    ));
  }
}
