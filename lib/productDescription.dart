import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/bloc/ProductBloc/ProductBloc.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'package:flutter_html/flutter_html.dart';

class ProductDescription extends StatelessWidget {
  String productId;
  ProductDescription(String _productId) {
    productId = _productId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProductBloc(ProductRepository(Dio())),
        child: ProductDescriptionStateful(productId),
      ),
    );
  }
}

class ProductDescriptionStateful extends StatefulWidget {
  String productId;
  ProductDescriptionStateful(String _productId) {
    productId = _productId;
  }

  @override
  _ProductDescriptionStatefulState createState() =>
      _ProductDescriptionStatefulState();
}

class _ProductDescriptionStatefulState
    extends State<ProductDescriptionStateful> {
  int number = 1;

  ProductData productData;
  int qty = 1;
  UserDataService userDataService = getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ProductBloc>(context)
        .add(FetchProductData(context: context, productId: widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(
            color: Colors.black, //change your color here
          ),
          actions: <Widget>[],
        ),
        body: SingleChildScrollView(
            child: BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductDataFetchState) {
              setState(() {
                productData = state.productData;
              });
            } else if (state is AddtoCartCompleteState) {
              setState(() {
                BlocProvider.of<ProductBloc>(context).add(FetchProductData(
                    context: context, productId: widget.productId));
              });
            } else if (state is EditCartListCompleteState) {
              setState(() {
                BlocProvider.of<ProductBloc>(context).add(FetchProductData(
                    context: context, productId: widget.productId));
              });
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                SizedBox(
                  child: (productData != null && productData.imgurl != "")
                      ? Image.network(
                          ApiConstants.IMAGE_URL +
                              productData.imgurl.toString(),
                          height: 140.h,
                        )
                      : SizedBox(
                          height: 140.h,
                        ),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                                child: (productData != null &&
                                        productData.name != "")
                                    ? Text(
                                        productData.name.toString(),
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      )
                                    : Text(
                                        "",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.sp),
                                      ))
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            (productData != null && productData.category != "")
                                ? Text(
                                    productData.category.toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.sp,
                                        color: Colors.black38),
                                  )
                                : Text(
                                    "",
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 16.sp,
                                        color: Colors.black38),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /*Text("30G", style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14.sp,
                                  color: Colors.black38
                              ),),*/
                      ],
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            child: (productData != null &&
                                    productData.b2bselprice != "" &&
                                    userDataService.userData.usertype == "2")
                                ? Text(
                                    "Rs. " + productData.b2bselprice.toString(),
                                    //         *
                                    //     double.parse(
                                    //         productData.qty.toString()))
                                    // .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp),
                                  )
                                : (productData != null &&
                                        productData.b2cselprice != "" &&
                                        userDataService.userData.usertype ==
                                            "1")
                                    ? Row(
                                        children: [
                                          Text(
                                            "Rs. " +
                                                productData.b2cselprice
                                                    .toString(),
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            "₹" + productData.mrp.toString(),
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13.sp),
                                          ),
                                        ],
                                      )
                                    : (productData != null &&
                                            productData.b2bselprice != "" &&
                                            userDataService.userData.usertype ==
                                                "1")
                                        ? Row(
                                            children: [
                                              Text(
                                                "Rs. " +
                                                    productData.b2bselprice
                                                        .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                "₹" +
                                                    productData.mrp.toString(),
                                                style: TextStyle(
                                                    decoration: TextDecoration
                                                        .lineThrough,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13.sp),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            "",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.sp),
                                          ),
                          ),
                          (productData != null &&
                                  productData.cartlist != null &&
                                  productData.cartlist != "")
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          if (int.parse(productData.qty) > 0) {
                                            qty = int.parse(productData.qty);
                                            qty = qty - 1;
                                            BlocProvider.of<ProductBloc>(
                                                    context)
                                                .add(EditCart(
                                                    context: context,
                                                    cartId:
                                                        productData.cartlist,
                                                    userId: userDataService
                                                        .userData.customerid,
                                                    qty: qty.toString()));
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Item quantity can not lesser than 0.")));
                                            //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                          }
                                        });
                                      },
                                      child: Container(
                                        height: 24.h,
                                        width: 24.w,
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                                color: Colors.white,
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
                                          color: Colors.white70,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          border: Border.all(
                                              color: Colors.black26, width: 1)),
                                      child: Center(
                                        child: Text(
                                          productData.qty.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 18.sp),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          qty = int.parse(productData.qty);
                                          qty = qty + 1;
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(EditCart(
                                                  context: context,
                                                  cartId: productData.cartlist,
                                                  userId: userDataService
                                                      .userData.customerid,
                                                  qty: qty.toString()));
                                        });
                                      },
                                      child: Container(
                                        height: 24.h,
                                        width: 24.w,
                                        decoration: BoxDecoration(
                                          color: Colors.black54,
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : GestureDetector(
                                  onTap: () {
                                    BlocProvider.of<ProductBloc>(context).add(
                                        AddToCartEvent(
                                            context: context,
                                            productId: productData.productid
                                                .toString(),
                                            userId: userDataService
                                                .userData.customerid,
                                            userType: userDataService
                                                .userData.usertype,
                                            productDataList: null,
                                            currentIndex: 0));
                                  },
                                  child: Container(
                                    height: 30.h,
                                    width: 80.w,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: Text(
                                        "ADD",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                          SizedBox(
                            width: 10.w,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                TabBar(
                  indicatorColor: Colors.grey.shade300,
                  tabs: [
                    Tab(
                      child: Text(
                        "Description",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    // Tab(
                    //   child: Text(
                    //     "Benefits",
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                    // Tab(
                    //   child: Text(
                    //     "Info",
                    //     textAlign: TextAlign.center,
                    //     style: TextStyle(color: Colors.black),
                    //   ),
                    // ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 30.h),
                          child: (productData != null &&
                                  productData.description != null)
                              ? Text(productData.description)
                              : Text(""),
                        ),
                        decoration: BoxDecoration(color: Colors.grey[100]),
                      ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Container(
                      //     padding: EdgeInsets.only(
                      //         left: 20.w, right: 20.w, top: 30.h),
                      //     child: (productData != null &&
                      //             productData.benifit != null)
                      //         ? Text(productData.benifit)
                      //         : Text(""),
                      //   ),
                      //   decoration: BoxDecoration(color: Colors.grey[100]),
                      // ),
                      // Container(
                      //   width: MediaQuery.of(context).size.width,
                      //   child: Container(
                      //     padding: EdgeInsets.only(
                      //         left: 20.w, right: 20.w, top: 30.h),
                      //     child:
                      //         (productData != null && productData.info != null)
                      //             ? Text(productData.info)
                      //             : Text(""),
                      //   ),
                      //   decoration: BoxDecoration(color: Colors.grey[100]),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
