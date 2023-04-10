import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickk/MyAddresses.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DialogUtils/DialogUtil.dart';
import 'package:quickk/bloc/HomeScreenBloc/HomeScreenBloc.dart';
import 'package:quickk/bloc/ProductBloc/ProductBloc.dart';
import 'package:quickk/bloc/WalletBloc/WalletBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/orderScreen.dart';
import 'package:quickk/provider/ProductProvider.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/repository/WalletRepository.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'modal/PromoList.dart';
//import 'package:razorpay_flutter/razorpay_flutter.dart';

class SelectPaymentOption extends StatelessWidget {
  String locationId, cartId, userId;

  SelectPaymentOption(String id, String _cartId, String _userId) {
    this.locationId = id;
    this.cartId = _cartId;
    this.userId = _userId;
  }

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
        BlocProvider(
          create: (context) => WalletBloc(WalletRepository(Dio())),
        ),
      ],
      child: SelectPaymentOptionStateful(locationId, cartId, userId),
    ));
  }
}

class SelectPaymentOptionStateful extends StatefulWidget {
  String locationId, cartId, userId;

  SelectPaymentOptionStateful(String id, String _cartId, String _userId) {
    this.locationId = id;
    this.cartId = _cartId;
    this.userId = _userId;
  }

  @override
  _SelectPaymentOptionState createState() => _SelectPaymentOptionState();
}

class _SelectPaymentOptionState extends State<SelectPaymentOptionStateful> {
  UserDataService userDataService = getIt<UserDataService>();
  LocationDataService locationDataService = getIt<LocationDataService>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<PromoList> promolist = List.empty(growable: true);
  List<CartData> cartDataList = List.empty(growable: true);
  double billAmount = 0.0;
  bool discountAmountAdd = false, useAmount = false;
  String address = "";
  TextEditingController promocodeController = new TextEditingController();
  String walletAmount = "";
  static const platform = const MethodChannel("razorpay_flutter");
  Razorpay _razorpay;
  String subtotal, Shipchrg, discount;
  double total = 0.0;
  @override
  void initState() {
    super.initState();
    // ProductProvider.Promolist();
    print(promolist.toString() + 'manoj');
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    if (locationDataService.locationData != null) {
      address = locationDataService.locationData.address1 +
          "," +
          locationDataService.locationData.address2 +
          "," +
          locationDataService.locationData.address3 +
          "," +
          locationDataService.locationData.pincode;
    }
    // ProductProvider(client).Promolist(context);
    BlocProvider.of<ProductBloc>(context).add(PromoListdata(context: context));
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<WalletBloc>(context).add(WalletListEvent(
        context: context, userId: userDataService.userData.customerid));
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    print('Success Response: $response');
    BlocProvider.of<ProductBloc>(context).add(AddOrder(
        context: context,
        userId: userDataService.userData.customerid,
        delieveryAddId: locationDataService.locationData.id));
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, toastLength: Toast.LENGTH_SHORT);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Error Response: $response');
    Fluttertoast.showToast(
        msg: "You've Cancel the payment.", toastLength: Toast.LENGTH_SHORT);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName,
        toastLength: Toast.LENGTH_SHORT);
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_live_YwlpEzrvfG6EP8',
      'amount': total * 100,
      'name': 'GROWFI SOLUTIONS PRIVATE LIMITED',
      'description': widget.cartId + " \t" + widget.userId,
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {
        'contact': userDataService.userData.mobileno.toString(),
        'email': userDataService.userData.emailid.toString()
      },
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: e');
    }
    print(cartDataList.length.toString() + 'l');
    print(promolist.length.toString() + 'l');
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
                    Text(
                      "Cart[" + cartDataList.length.toString() + "]",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocListener<ProductBloc, ProductState>(
        listener: (context, state) {
          if (state is PromoListCompleteState) {
            setState(() {
              promolist = state.promolist;
            });
          }
          if (state is CartDataCompleteState) {
            setState(() {
              billAmount = 0.0;
              cartDataList = state.cartDataList;
              subtotal = state.subtotal;
              Shipchrg = state.Shipchrg;
              discount = state.discount;
              total = double.parse(state.total);
              for (int i = 0; i < cartDataList.length; i++) {
                billAmount = billAmount +
                    (double.parse(cartDataList[i].b2bselprice) *
                        double.parse(cartDataList[i].qty.toString()));
              }
            });
          }
          if (state is OrderCompleteState) {
            Get.to(OrderScreen());
            //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => OrderScreen(), transitionDuration: Duration.zero,),);
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
              // print(state.billAmount);
              print(total.toString() + 'mj');
              double grandtotal = total;
              // grandtotal = total;
              discount = state.discount;
              double discountAmount = double.parse(state.discount.toString());
              billAmount = billAmount - discountAmount;
              total = grandtotal - discountAmount;
              // total = int.parse(total.toString()-state.discount.toString());
              print(billAmount);
            });
          }
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black12,
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
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          Text(
                            "Congratulation! you've unlocked Free Delivery",
                            style: TextStyle(fontSize: 10, color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Deliver to:",
                            style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Text(
                            userDataService.userData.firstname +
                                " " +
                                userDataService.userData.lastname,
                            style: TextStyle(
                                fontSize: 17.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              address,
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  // height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 50.h,
                        padding: EdgeInsets.only(left: 5.w, right: 5.w),
                        color: Colors.black87,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                                child: Image.asset(
                              "assets/icons/discount.png",
                              height: 20.h,
                            )),
                            SizedBox(
                              width: 5.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "AVAIL OFFERS/ \nCOUPON",
                                    style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            (discountAmountAdd == true)
                                ? Container(
                                    height: 30.h,
                                    width: 150.w,
                                    child: Center(
                                        child: Text(
                                      "Applied",
                                      style: TextStyle(
                                          fontSize: 14.sp, color: Colors.white),
                                    )),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  )
                                : Text(""),
                          ],
                        ),
                      ),
                      (discountAmountAdd == false)
                          ? Container(
                              height: 40.h,
                              //width: MediaQuery.of(context).size.width.w/1.6.w,

                              decoration: BoxDecoration(
                                  color: Color(0xffefefef),
                                  border: Border.all(
                                      color: Colors.white, width: 1.w),
                                  borderRadius: BorderRadius.circular(5)),
                              margin: EdgeInsets.only(
                                top: 10.w,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                      child: TextFormField(
                                          controller: promocodeController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: "Add Promo code",
                                            errorMaxLines: 1,
                                            // errorText: (state.mobileNumber.valid) ? null : (state.mobileNumber.value != "" && !state.mobileNumber.valid && state.mobileNumber.value.length > 10) ?  "Invalid Mobile Number" : null,
                                            errorStyle: TextStyle(
                                                color: Colors.red,
                                                fontSize: 12.sp),
                                          ),
                                          keyboardType: TextInputType.text,
                                          onChanged: (value) {})),
                                  InkWell(
                                    onTap: () {
                                      print(promocodeController.text);
                                      print(
                                        userDataService.userData.customerid,
                                      );
                                      print(billAmount.toString());
                                      BlocProvider.of<ProductBloc>(context).add(
                                          AddPromoCode(
                                              context: context,
                                              userId: userDataService
                                                  .userData.customerid,
                                              promocode:
                                                  promocodeController.text,
                                              billamount:
                                                  billAmount.toString()));
                                    },
                                    child: Container(
                                      height: 30.h,
                                      width: 50.w,
                                      margin: EdgeInsets.only(right: 10.w),
                                      child: Center(
                                          child: Text(
                                        "Apply",
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            color: Colors.white),
                                      )),
                                      decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ],
                              ))
                          : Text(""),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Tap to apply promo',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: List.generate(
                              promolist.length,
                              (index) => Container(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            promocodeController.text =
                                                promolist[index].code;
                                          },
                                          child: Card(
                                            elevation: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Text(
                                                      "${promolist[index].code}"
                                                      "  "
                                                      "${promolist[index].value}"
                                                      "${promolist[index].type}",
                                                      style: TextStyle(
                                                          fontSize: 18.sp,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  promocodeController.text ==
                                                          promolist[index].code
                                                      ? Text(
                                                          'Applied',
                                                          style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      88,
                                                                      225,
                                                                      142),
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500),
                                                        )
                                                      : Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Text("Valid till",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                            SizedBox(
                                                              height: 3,
                                                            ),
                                                            Text(
                                                                promolist[index]
                                                                    .enddate
                                                                    .toString()
                                                                    .substring(
                                                                        0, 10),
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .red,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500)),
                                                          ],
                                                        ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  height: 70.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BlocListener<WalletBloc, WalletState>(
                          listener: (context, state) {
                            if (state is WalletCompleteState) {
                              setState(() {
                                walletAmount = state.walletAmount;
                              });
                            }
                          },
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Use Wallet Amount \n Rs. " +
                                            walletAmount,
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                  Checkbox(
                                    checkColor: Colors.white,
                                    activeColor: Colors.red,
                                    value: useAmount,
                                    onChanged: (value) {
                                      setState(() {
                                        useAmount = value;
                                        String beforWalletAmount = walletAmount;
                                        if (useAmount == true &&
                                            billAmount <
                                                double.parse(
                                                    walletAmount.toString())) {
                                          double remainingAmount =
                                              (double.parse(
                                                      walletAmount.toString()) -
                                                  billAmount);
                                          walletAmount = (double.parse(
                                                      walletAmount.toString()) -
                                                  remainingAmount)
                                              .toString();
                                          billAmount =
                                              double.parse(walletAmount) -
                                                  billAmount;
                                        } else {
                                          BlocProvider.of<ProductBloc>(context)
                                              .add(FetchCartList(
                                                  context: context,
                                                  userId: userDataService
                                                      .userData.customerid));
                                          BlocProvider.of<WalletBloc>(context)
                                              .add(WalletListEvent(
                                                  context: context,
                                                  userId: userDataService
                                                      .userData.customerid));
                                        }
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  width: MediaQuery.of(context).size.width.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(10.0)),
                  ),
                  margin: EdgeInsets.only(left: 10.w, right: 10.w),
                  padding: EdgeInsets.only(
                      left: 15.w, right: 15.w, top: 15.h, bottom: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "SubTotal",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            subtotal.toString() + " Rs/-",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Shipping Charge",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            Shipchrg.toString() + " Rs/-",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Discount",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            discount.toString() + " Rs/-",
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              "Total Amount",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Text(
                            total.toString() + " Rs/-",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          // Text(
                          //   total.toString() + " Rs/-",
                          //   style: TextStyle(
                          //       fontSize: 12.sp,
                          //       color: Colors.black,
                          //       fontWeight: FontWeight.bold),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
      bottomNavigationBar: Container(
        height: 100.h,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: Colors.grey),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /*Container(
                  height: 50.h,
                  padding: EdgeInsets.only(left: 10.w, right: 0.w),
                  color: Colors.black87,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                          child:  Image.asset("assets/icons/discount.png",  height: 15.h,)
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("AVAIL OFFERS/ \nCOUPON", style: TextStyle(fontSize: 10.sp,color: Colors.white,fontWeight: FontWeight.bold),),
                        ],
                      ),
                      SizedBox(width:10.w),
                      (discountAmountAdd == false) ? Container(
                        height: 30.h,
                        width: 200.w,
                        child: Center(child: Text("Applied promocode", style: TextStyle( fontSize: 14.sp, color: Colors.white),)),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ):Container(

                          height: 40.h,
                          width: MediaQuery.of(context).size.width.w/1.6.w,

                          decoration: BoxDecoration(
                              color: Color(0xffefefef),
                              border: Border.all(color:Colors.white,width: 1.w),
                              borderRadius: BorderRadius.circular(5)
                          ),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 5.w,),

                              Expanded(child: TextFormField(
                                  controller: promocodeController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Add Promo code",
                                    errorMaxLines: 1,
                                    //errorText: (state.mobileNumber.valid) ? null : (state.mobileNumber.value != "" && !state.mobileNumber.valid && state.mobileNumber.value.length > 10) ?  "Invalid Mobile Number" : null,
                                    errorStyle: TextStyle(color: Colors.red, fontSize: 12.sp),
                                  ),
                                  keyboardType: TextInputType.text,
                                  onChanged: (value) {

                                  }
                              )),
                              InkWell(
                                onTap: (){
                                  BlocProvider.of<ProductBloc>(context).add(AddPromoCode(context: context, userId:userDataService.userData.customerid,promocode:promocodeController.text,billamount:billAmount.toString()));
                                },
                                child: Container(
                                  height: 30.h,
                                  width: 50.w,
                                  child: Center(child: Text("Apply", style: TextStyle( fontSize: 14.sp, color: Colors.white),)),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),),
                              SizedBox(width: 5.w,)



                            ],
                          )

                      ),

                    ],
                  ),
                ),*/
            SizedBox(
              height: 10.h,
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
                        "RS. " + total.toString(),
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
                          if (double.parse(total.toString()) > 0.0) {
                            //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => SelectPaymentOption(locationDataService.locationData.id), transitionDuration: Duration.zero,),);
                            openCheckout();
                          } else {
                            BlocProvider.of<ProductBloc>(context).add(AddOrder(
                                context: context,
                                userId: userDataService.userData.customerid,
                                delieveryAddId:
                                    locationDataService.locationData.id));
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
