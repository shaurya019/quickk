import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/BottomNavigationWidget.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DataNotAvailable.dart';
import 'package:quickk/bloc/OrderBloc/OrderBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/modal/OrderData.dart';
import 'package:quickk/orderDetail.dart';
import 'package:quickk/repository/OrderRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OrderBloc(OrderRepository(Dio())),
        child: OrderScreenStateful(),
      ),
    );
  }
}

class OrderScreenStateful extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreenStateful> {
  List<OrderData> orderList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();
  BuildContext dialogContext;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<OrderBloc>(context).add(OrderListEvent(
        context: context,
        userId: userDataService.userData.customerid,
        fromCancelOrder: false));
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
              appBar: PreferredSize(
                  preferredSize: Size.fromHeight(70.0),
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 10.h, left: 10.w),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            //Get.to(HomeScreen());
                            Navigator.pop(context);
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(
                            child: Text(
                          "Order",
                          style:
                              TextStyle(color: Colors.black, fontSize: 20.sp),
                        )),
                        // Container(
                        //   height: 24.h,
                        //   width: 60.w,
                        //   margin: EdgeInsets.only(right: 20.w),
                        //   decoration: BoxDecoration(
                        //       color: Colors.red,
                        //       borderRadius: BorderRadius.circular(10)),
                        //   child: Center(
                        //     child: Text("Get Help", style: TextStyle( color: Colors.white),),
                        //   ),
                        // )
                      ],
                    ),
                  )),
              backgroundColor: Colors.white,
              body: BlocListener<OrderBloc, OrderState>(
                listener: (context, state) {
                  dialogContext = context;
                  if (state is OrderCompleteState) {
                    setState(() {
                      orderList = state.orderList;
                    });
                  }
                  if (state is CancelOrderCompleteState) {
                    BlocProvider.of<OrderBloc>(context).add(OrderListEvent(
                        context: dialogContext,
                        userId: userDataService.userData.customerid,
                        fromCancelOrder: true));
                  }
                },
                child: SingleChildScrollView(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Container(
                            width: 300.w,
                            child: (orderList != null)
                                ? ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemCount: orderList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          Get.to(OrderDetail(orderList[index]));
                                          //Navigator.push(context, MaterialPageRoute(builder: (Context)=>OrderDetail(orderList[index])));
                                        },
                                        child: Container(
                                            width: 300.w,
                                            height: 100.h,
                                            margin: EdgeInsets.only(
                                                bottom: 15.h, top: 0.h),
                                            padding: EdgeInsets.only(top: 5.h),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color: Colors.black26,
                                                )),
                                            child: Stack(
                                              children: [
                                                Positioned(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      CircleAvatar(
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        radius: 20,
                                                        child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20)),
                                                            child: Image.asset(
                                                                "assets/icons/avatar-scalable-vector-graphics-user-profile-icon-png-favpng-vTrkzrX6XUYwzVx1NydaX01ei.jpg")),
                                                      ),
                                                      SizedBox(
                                                        width: 10.w,
                                                      ),
                                                      Text(
                                                        userDataService.userData
                                                                .firstname +
                                                            " " +
                                                            userDataService
                                                                .userData
                                                                .lastname,
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Positioned(
                                                    top: 24.h,
                                                    left: 10.w,
                                                    child: Row(
                                                      children: [
                                                        SizedBox(
                                                          child: Image.network(
                                                            ApiConstants
                                                                    .BASE_URL +
                                                                orderList[index]
                                                                    .orderdetails[
                                                                        0]
                                                                    .imgurl,
                                                            height: 40.h,
                                                            width: 50.w,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Container(
                                                          height: 70.h,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              /*Text("HERBAL CIGARETTES", style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12.sp
                                            ),),*/
                                                              Text(
                                                                "ORDER ID: " +
                                                                    orderList[
                                                                            index]
                                                                        .orderid,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12.sp,
                                                                    color: Colors
                                                                        .black38),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                Positioned(
                                                    top: 5.h,
                                                    left: 190.w,
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          height: 80.h,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              Text(
                                                                "ORDER AMOUNT",
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12.sp),
                                                              ),
                                                              /*Text("30G", style: TextStyle(
                                                fontWeight: FontWeight.bold, fontSize: 12.sp,
                                                color: Colors.black38
                                            ),),*/
                                                              Text(
                                                                "RS. " +
                                                                    orderList[
                                                                            index]
                                                                        .billingamount,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        12.sp),
                                                              ),
                                                              (orderList[index]
                                                                          .Status ==
                                                                      "Cancel")
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {},
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            22.h,
                                                                        width:
                                                                            80.w,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Cancelled",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text(""),
                                                              (orderList[index]
                                                                          .Status !=
                                                                      "Cancel")
                                                                  ? GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        showDialog(
                                                                            context:
                                                                                context,
                                                                            builder:
                                                                                (context) {
                                                                              return CancelDialog(orderList[index].orderid, dialogContext);
                                                                            });
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            22.h,
                                                                        width:
                                                                            80.w,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "Cancel",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : Text("")
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                              ],
                                            )),
                                      );
                                    },
                                  )
                                : Expanded(
                                    child: DataNotAvailable.dataNotAvailable(
                                        "Orders not Available."))),
                      ],
                    ),
                  ),
                ),
              ),
              bottomNavigationBar: BottomNavigationWidget(2))),
    );
  }
}

class CancelDialog extends StatelessWidget {
  String orderId;
  BuildContext dialogContext;

  CancelDialog(String _orderId, BuildContext _context) {
    orderId = _orderId;
    dialogContext = _context;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => OrderBloc(OrderRepository(Dio())),
      child: CancelDialogStateful(orderId, dialogContext),
    );
  }
}

class CancelDialogStateful extends StatefulWidget {
  String orderId;
  BuildContext dialogContext;

  CancelDialogStateful(String _orderId, BuildContext _context) {
    orderId = _orderId;
    dialogContext = _context;
  }

  @override
  _CancelDialogState createState() => _CancelDialogState();
}

class _CancelDialogState extends State<CancelDialogStateful>
    with SingleTickerProviderStateMixin {
  AnimationController animationController;
  TextEditingController cancelReasonController = new TextEditingController();
  UserDataService userDataService = getIt<UserDataService>();
  BuildContext dialogContext, widgetContext;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    widgetContext = context;
    return BlocListener<OrderBloc, OrderState>(
        listener: (context, state) {
          dialogContext = context;
          if (state is CancelOrderCompleteState) {
            BlocProvider.of<OrderBloc>(context).add(OrderListEvent(
                context: widget.dialogContext,
                userId: userDataService.userData.customerid,
                fromCancelOrder: true));
          }
        },
        child: AlertDialog(
          title: Text(
            'Cancellation Reason',
            style: TextStyle(color: ColorConstants.primaryColor),
          ),
          content: Card(
            child: Container(
                width: 300.w,
                height: 70.h,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                        child: TextFormField(
                            maxLines: 3,
                            controller: cancelReasonController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Reason",
                              errorMaxLines: 1,
                              //errorText: (state.email.value == null && state.email.invalid && state.email.value.length < 5 ) ? "Invalid Email" : null,
                              errorStyle:
                                  TextStyle(color: Colors.red, fontSize: 12.sp),
                            ),
                            keyboardType: TextInputType.text,
                            onChanged: (value) {})),
                  ],
                )),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: new BorderSide(color: Colors.white, width: 1.0),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Back'),
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  primary: ColorConstants.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  textStyle:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
            ElevatedButton(
              child: Text('Continue'),
              onPressed: () {
                Navigator.pop(widget.dialogContext);
                BlocProvider.of<OrderBloc>(widget.dialogContext).add(
                    CancelOrderEvent(
                        context: widget.dialogContext,
                        orderId: widget.orderId,
                        cancelReason: cancelReasonController.text,
                        userId: userDataService.userData.customerid));
              },
              style: ElevatedButton.styleFrom(
                  primary: ColorConstants.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  textStyle:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
          ],
        ));
  }
}
