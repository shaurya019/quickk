import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/MyAddresses.dart';
import 'package:quickk/SelectPaymentOption.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DataNotAvailable.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/bloc/HomeScreenBloc/HomeScreenBloc.dart';
import 'package:quickk/bloc/ProductBloc/ProductBloc.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/modal/PromoList.dart';
import 'package:quickk/orderScreen.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

class ShopingCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(ProductRepository(Dio())),
        ),
        BlocProvider(
          create: (context) => HomeScreenBloc(HomeScreenRepository(Dio())),
        ),
      ],
      child: ShopingCartStateful(),
    ));
  }
}

class ShopingCartStateful extends StatefulWidget {
  @override
  _ShopingCartStatefulState createState() => _ShopingCartStatefulState();
}

class _ShopingCartStatefulState extends State<ShopingCartStateful> {
  int number = 1;
  UserDataService userDataService = getIt<UserDataService>();
  List<CartData> cartDataList = List.empty(growable: true);
  int containerLength = 0;
  int qty = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProductData> recomProductDataList = List.empty(growable: true);
  double billAmount = 0.0;
  LocationDataService locationDataService = getIt<LocationDataService>();
  String address = "";
  TextEditingController promocodeController = new TextEditingController();
  bool discountAmountAdd = false;
  double sellingPrice = 0.0;
  double orignalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    if (locationDataService.locationData != null) {
      address = locationDataService.locationData.address1 +
          "," +
          locationDataService.locationData.address2 +
          "," +
          locationDataService.locationData.address3 +
          "," +
          locationDataService.locationData.pincode;
    }
    getloaddata();
  }

  getloaddata() {
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(
        context: context, userId: userDataService.userData.customerid));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50.0),
        child: Container(
          height: 45.h,
          padding: EdgeInsets.only(left: 10.w, right: 10.w),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          size: 22,
                        )),
                    SizedBox(
                      width: 10.w,
                    ),
                    (cartDataList != null)
                        ? Text(
                            "Cart[" + cartDataList.length.toString() + "]",
                            style: TextStyle(fontSize: 16),
                          )
                        : Text(
                            "Cart[" + "0".toString() + "]",
                            style: TextStyle(fontSize: 16),
                          )
                  ],
                ),
              ),
              GestureDetector(
                  onTap: () {},
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
                width: 5.w,
              )
            ],
          ),
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is CartDataCompleteState) {
            setState(() {
              billAmount = 0.0;
              cartDataList = state.cartDataList;
              if (cartDataList != null) {
                for (int i = 0; i < cartDataList.length; i++) {
                  if (userDataService.userData.usertype == "1") {
                    billAmount = billAmount +
                        (double.parse(cartDataList[i].b2cselprice) *
                            double.parse(cartDataList[i].qty.toString()));
                  } else if (userDataService.userData.usertype == "2") {
                    billAmount = billAmount +
                        (double.parse(cartDataList[i].b2bselprice) *
                            double.parse(cartDataList[i].qty.toString()));
                  }
                }
                containerLength = 100 * cartDataList.length;
              }
            });
          }
          if (state is OrderCompleteState) {
            //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => OrderScreen(), transitionDuration: Duration.zero,),);
            Get.to(OrderScreen());
            var snackBar =
                SnackBar(content: Text("Order Created Successfully."));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          if (state is EditCartListCompleteState) {
            BlocProvider.of<ProductBloc>(context).add(FetchCartList(
                context: context, userId: userDataService.userData.customerid));
          }
          if (state is DeleteFromCartCompleteState) {
            BlocProvider.of<ProductBloc>(context).add(FetchCartList(
                context: context, userId: userDataService.userData.customerid));
          }
          if (state is PromocodeCompleteState) {
            setState(() {
              discountAmountAdd = true;
              double discountAmount = double.parse(state.discount);
              billAmount = billAmount - discountAmount;
            });
          } else if (state is AddtoCartCompleteState) {
            setState(() {
              BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(
                  context: context,
                  userId: userDataService.userData.customerid));
              BlocProvider.of<ProductBloc>(context).add(FetchCartList(
                  context: context,
                  userId: userDataService.userData.customerid));
            });
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                BlocListener<HomeScreenBloc, HomeScreenState>(
                  listener: (context, state) {
                    if (state is HomeDataListCompleteState) {
                      setState(() {
                        recomProductDataList = state.recomProductDataList;
                      });
                    }
                  },
                  child: Text(""),
                ),
                Expanded(
                    child: ListView(
                  shrinkWrap: true,
                  children: [
                    Container(
                      width: 500.w,
                      height: 1,
                      color: Colors.black26,
                    ),
                    Container(
                      height: 50.h,
                      padding: EdgeInsets.only(left: 10.w, right: 10.w),
                      color: Colors.black87,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              child: Image.asset(
                            "assets/icons/img.png",
                            color: Colors.red,
                            height: 40.h,
                          )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "FREE DELIVERY",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.white),
                              ),
                              Text(
                                "Congratulation! you've unlocked Free Delivery",
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                        ],
                      ),
                    ),
                    (cartDataList != null && cartDataList.length > 0)
                        ? Container(
                            width: MediaQuery.of(context).size.width.w,
                            height: containerLength.h,
                            margin: EdgeInsets.only(
                                left: 0.w, right: 0.w, top: 10.h),
                            padding: EdgeInsets.all(0),
                            child: ListView.builder(
                                itemCount: cartDataList.length,
                                physics: NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  sellingPrice = 0.0;
                                  orignalPrice = 0.0;
                                  if (userDataService.userData.usertype ==
                                      "1") {
                                    sellingPrice = double.parse(
                                        cartDataList[index]
                                            .b2cselprice
                                            .toString());
                                    //          *
                                    // int.parse(
                                    //     cartDataList[index].qty.toString());
                                    // orignalPrice = double.parse(
                                    //         cartDataList[index]
                                    //             .mrp
                                    //             .toString()) *
                                    //     int.parse(
                                    //         cartDataList[index].qty.toString());
                                  } else if (userDataService
                                          .userData.usertype ==
                                      "2") {
                                    sellingPrice = double.parse(
                                        cartDataList[index]
                                            .b2bselprice
                                            .toString());
                                    //         *
                                    // int.parse(
                                    //     cartDataList[index].qty.toString());
                                  }
                                  return Container(
                                      //margin: EdgeInsets.only(top: 5.h),
                                      padding: EdgeInsets.all(0),
                                      height: 100.h,
                                      width:
                                          MediaQuery.of(context).size.width.w,
                                      decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Container(
                                                height: 80.h,
                                                width: 80.w,
                                                margin: EdgeInsets.only(
                                                    left: 10.w,
                                                    right: 10.w,
                                                    top: 0.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 0.8,
                                                      color: Colors.grey),
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(
                                                          5.0) //                 <--- border radius here
                                                      ),
                                                ),
                                                child: Image.network(
                                                  ApiConstants.IMAGE_URL +
                                                      cartDataList[index]
                                                          .imgurl,
                                                  height: 80.h,
                                                  width: 80.w,
                                                ),
                                              ),
                                              Expanded(
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          cartDataList[index]
                                                              .name,
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 15.sp),
                                                        )),
                                                        GestureDetector(
                                                          onTap: () {
                                                            setState(() {
                                                              BlocProvider.of<
                                                                          ProductBloc>(
                                                                      context)
                                                                  .add(DeleteFromCart(
                                                                      context:
                                                                          context,
                                                                      cartId:
                                                                          cartDataList[index]
                                                                              .id,
                                                                      cartDataList:
                                                                          cartDataList));
                                                              getloaddata();
                                                            });
                                                          },
                                                          child: Icon(
                                                            Icons.delete,
                                                            color: Colors.red,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Expanded(
                                                            child: Row(
                                                          children: [
                                                            Icon(
                                                              Icons
                                                                  .currency_rupee_outlined,
                                                              size: 15.sp,
                                                            ),
                                                            Text(
                                                              sellingPrice
                                                                  .toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ],
                                                        )),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 20.w),
                                                          child: Row(
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    if (int.parse(
                                                                            cartDataList[index].qty) >
                                                                        0) {
                                                                      qty = int.parse(
                                                                          cartDataList[index]
                                                                              .qty);
                                                                      qty =
                                                                          qty -
                                                                              1;
                                                                      BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                          context:
                                                                              context,
                                                                          cartId: cartDataList[index]
                                                                              .id,
                                                                          userId: userDataService
                                                                              .userData
                                                                              .customerid,
                                                                          qty: qty
                                                                              .toString()));
                                                                      print(
                                                                          'mmm');
                                                                      getloaddata();
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              SnackBar(content: Text("Item quantity can not lesser than 0.")));
                                                                      //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                    }
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 24.h,
                                                                  width: 24.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .red,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
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
                                                                        width:
                                                                            1)),
                                                                child: Center(
                                                                  child: Text(
                                                                    cartDataList[
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
                                                                      () async {
                                                                    qty = int.parse(
                                                                        cartDataList[index]
                                                                            .qty);
                                                                    qty =
                                                                        qty + 1;
                                                                    await BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                        context:
                                                                            context,
                                                                        cartId: cartDataList[index]
                                                                            .id,
                                                                        userId: userDataService
                                                                            .userData
                                                                            .customerid,
                                                                        qty: qty
                                                                            .toString()));
                                                                    getloaddata();
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  height: 24.h,
                                                                  width: 24.w,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black54,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(5),
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
                                                                width: 3.w,
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width
                                                .w,
                                            height: 0.2.h,
                                            color: Colors.grey,
                                          )
                                        ],
                                      ));
                                }),
                          )
                        : Container(
                            height: 250.h,
                            child: DataNotAvailable.dataNotAvailable(
                                "No products in cart.")),
                    Container(
                      width: MediaQuery.of(context).size.width.w,
                      margin: EdgeInsets.only(left: 20.w, right: 20.w),
                      height: 4.h,
                      color: Colors.purple[100],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "You might be interested in",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12.sp),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width.w,
                      margin: EdgeInsets.only(left: 20.w, right: 20.w),
                      height: 1.h,
                      color: Colors.purple,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Container(
                        width: MediaQuery.of(context).size.width.w,
                        height: 250.h,
                        margin: EdgeInsets.only(left: 10.w, right: 10.w),
                        child: Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 210.h,
                                child: ListView.builder(
                                    itemCount: recomProductDataList.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      sellingPrice = 0.0;
                                      if (userDataService.userData.usertype ==
                                          "1") {
                                        orignalPrice = double.parse(
                                            recomProductDataList[index]
                                                .mrp
                                                .toString());
                                        //          *
                                        // int.parse(
                                        //     recomProductDataList[index]
                                        //         .qty
                                        //         .toString());
                                        sellingPrice = double.parse(
                                            recomProductDataList[index]
                                                .b2cselprice
                                                .toString());
                                        //          *
                                        // int.parse(
                                        //     recomProductDataList[index]
                                        //         .qty
                                        //         .toString());
                                      } else if (userDataService
                                              .userData.usertype ==
                                          "2") {
                                        orignalPrice = double.parse(
                                            recomProductDataList[index]
                                                .mrp
                                                .toString());
                                        //          *
                                        // int.parse(
                                        //     recomProductDataList[index]
                                        //         .qty
                                        //         .toString());
                                        sellingPrice = double.parse(
                                            recomProductDataList[index]
                                                .b2bselprice
                                                .toString());
                                        //          *
                                        // int.parse(
                                        //     recomProductDataList[index]
                                        //         .qty
                                        //         .toString());
                                      }
                                      return GestureDetector(
                                        onTap: () {
                                          Get.to(ProductDescription(
                                                  recomProductDataList[index]
                                                      .productid))
                                              .then((value) => getloaddata());
                                        },
                                        child: Container(
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.only(
                                              bottom: 0.h, right: 10.w),
                                          //height: 280.h,
                                          width: 140.w,
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
                                                                    recomProductDataList[
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
                                                    //                     wishListId:
                                                    //                         recomProductDataList[index]
                                                    //                             .wishlist,
                                                    //                     productDataList:
                                                    //                         recomProductDataList,
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
                                                    //                         recomProductDataList[index]
                                                    //                             .productid,
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
                                                height: 110.h,
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
                                                        GestureDetector(
                                                            onTap: () {},
                                                            child: (recomProductDataList[index]
                                                                            .cartlist !=
                                                                        null &&
                                                                    recomProductDataList[index]
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
                                                                            if (int.parse(recomProductDataList[index].qty) >
                                                                                0) {
                                                                              qty = int.parse(recomProductDataList[index].qty);
                                                                              qty = qty - 1;
                                                                              BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: recomProductDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                              getloaddata();
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
                                                                            recomProductDataList[index].qty.toString(),
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
                                                                                int.parse(recomProductDataList[index].qty);
                                                                            qty =
                                                                                qty + 1;
                                                                            BlocProvider.of<ProductBloc>(context).add(EditCart(
                                                                                context: context,
                                                                                cartId: recomProductDataList[index].cartlist,
                                                                                userId: userDataService.userData.customerid,
                                                                                qty: qty.toString()));
                                                                            getloaddata();
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
                                                                          productId: recomProductDataList[index]
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
                                                    // Row(
                                                    //   crossAxisAlignment:
                                                    //       CrossAxisAlignment
                                                    //           .center,
                                                    //   mainAxisAlignment:
                                                    //       MainAxisAlignment
                                                    //           .center,
                                                    //   children: [
                                                    //     Text(
                                                    //       "  Rs. " +
                                                    //           sellingPrice
                                                    //               .toString(),
                                                    //       style: TextStyle(
                                                    //           fontWeight:
                                                    //               FontWeight
                                                    //                   .bold,
                                                    //           fontSize: 12.sp),
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
                                    }),
                              )
                            ],
                          ),
                        )),
                    SizedBox(
                      height: 200.h,
                    ),
                  ],
                )),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.black12),
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15.w,
                ),
                Expanded(
                    child: Text(
                  address.length > 20
                      ? address.substring(0, 20) + '...'
                      : address,
                  style: TextStyle(fontSize: 12, color: Colors.black),
                )),
                SizedBox(
                  width: 5.w,
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(MyAdresses());
                    //Navigator.push(context, MaterialPageRoute(builder: (Context)=>MyAdresses()));
                  },
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/icons/placeholder.png",
                        height: 12.h,
                      ),
                      Text(
                        "CHANGE ADDRESS",
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        "RS. " + billAmount.toString(),
                        style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3.h,
                      ),
                      Text(
                        "VIEW BILL",
                        style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: InkWell(
                        onTap: () {
                          if (cartDataList.length > 0) {
                            if (address != null && address != "") {
                              Get.to(SelectPaymentOption(
                                  locationDataService.locationData.id,
                                  cartDataList[0].id,
                                  userDataService.userData.customerid));
                              //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => SelectPaymentOption(locationDataService.locationData.id,cartDataList[0].id,userDataService.userData.customerid), transitionDuration: Duration.zero,),);
                              //BlocProvider.of<ProductBloc>(context).add(AddOrder(context: context, userId:userDataService.userData.customerid,delieveryAddId:locationDataService.locationData.id));
                            } else {
                              DialogUtil.showInfoDialog(
                                  "Address", "Please select address.", context);
                            }
                          } else {
                            DialogUtil.showInfoDialog(
                                "Empty Cart", "Please add product.", context);
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: 150.w,
                          margin: EdgeInsets.only(left: 10.w),
                          child: Center(
                              child: Text(
                            "Place Order",
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.white),
                          )),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ))
              ],
            )
          ],
        ),
      ),
    ));
  }
}
