import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Utils/DateTimeFormatter.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/OrderData.dart';

class OrderDetail extends StatefulWidget {
  OrderData orderData;

  OrderDetail(OrderData _orderData) {
    this.orderData = _orderData;
  }

  @override
  _OrderDetailState createState() => _OrderDetailState();
}

class _OrderDetailState extends State<OrderDetail> {
  int containerLength = 0;

  @override
  void initState() {
    super.initState();
    containerLength = 100 * widget.orderData.orderdetails.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Order Details",
          style: TextStyle(color: Colors.black, fontSize: 15.sp),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        titleSpacing: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: [
          Column(
            children: [
              Container(
                height: 12.h,
                width: 60.w,
              ),
              // Container(
              //   height: 25.h,
              //   width: 60.w,

              //   margin: EdgeInsets.only(right: 20.w),

              //   decoration: BoxDecoration(
              //       color: Colors.red,
              //       borderRadius: BorderRadius.circular(10)),

              //   child: Center(
              //     child: Text("Get Help", style: TextStyle( color: Colors.white),),
              //   ),

              // ),
            ],
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            /* Container(
                height: 40.h,
                padding: EdgeInsets.only(left: 10.w, right: 10.w),
                color: Colors.black87,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Rs.59 Saved on this order", style: TextStyle(fontSize: 16,color: Colors.white),),

                      ],
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                  ],
                ),
              ),*/
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ORDER ID : " + widget.orderData.orderid,
                      style: TextStyle(fontSize: 13.sp, color: Colors.black54),
                    ),
                    Text(
                      DateFormatter.getDayMonthYearFormat(
                              widget.orderData.DeliveryDate.toString()) +
                          " " +
                          DateFormatter.getTime(
                              widget.orderData.DeliveryDate.toString()),
                      style: TextStyle(fontSize: 13.sp, color: Colors.black38),
                    ),
                  ],
                ),
                Container(
                  width: 100.w,
                  height: 25.h,
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(20)),
                  child: Center(
                      child: Text(
                    widget.orderData.Status.toString(),
                    style: TextStyle(color: Colors.white),
                  )),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 15.h,
                ),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            alignment: Alignment.bottomLeft,
                            children: [
                              Container(
                                width: 100.w,
                                height: 25.h,
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  "ORDER ARRIVED IN",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 8.sp),
                                )),
                              ),
                              Container(
                                height: 50.h,
                              ),
                              Positioned(
                                  top: 10,
                                  child: Image.asset(
                                    "assets/icons/clock (1).png",
                                    height: 30,
                                  )),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "04:39 MINS",
                            style: TextStyle(
                                fontSize: 13.sp, color: Colors.black54),
                          ),
                        ],
                      ),
                    )),
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          Container(
                            width: 100.w,
                            height: 25.h,
                            decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(20)),
                            child: Center(
                                child: Text(
                              "DELIVERED TO",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 8.sp),
                            )),
                          ),
                          Container(
                            height: 50.h,
                          ),
                          Positioned(
                              top: 10,
                              child: Image.asset(
                                "assets/icons/placeholder.png",
                                height: 30,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.orderData.Address1 +
                                  "," +
                                  widget.orderData.Address2 +
                                  "," +
                                  widget.orderData.Address3 +
                                  "," +
                                  widget.orderData.pincode,
                              style: TextStyle(
                                  fontSize: 13.sp, color: Colors.black54),
                            ),
                          ),
                          SizedBox(
                            width: 5.h,
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 1,
              width: 300.w,
              color: Colors.black26,
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              width: MediaQuery.of(context).size.width.w,
              height: containerLength.h,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.orderData.orderdetails.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      height: 100.h,
                      width: 300.w,
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.black12,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: Stack(
                        children: [
                          Positioned(
                              top: 16.h,
                              left: 10.w,
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Image.network(
                                      ApiConstants.BASE_URL +
                                          widget.orderData.orderdetails[index]
                                              .imgurl,
                                      height: 70.h,
                                      width: 100.w,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Container(
                                    height: 70.h,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.orderData.orderdetails[index]
                                              .name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              widget.orderData
                                                  .orderdetails[index].qty,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15.sp,
                                                  color: Colors.black38),
                                            ),
                                            Text(
                                              "Rs. " +
                                                  widget
                                                      .orderData
                                                      .orderdetails[index]
                                                      .totalamount,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12.sp),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          /*Positioned(
                                left: 200.w,
                                top: 70.h,
                                child: Row(
                                  children: [

                                    Icon(Icons.star, color: Colors.red, size: 16,),
                                    Icon(Icons.star, color: Colors.red, size: 16,),
                                    Icon(Icons.star, color: Colors.red, size: 16,),
                                    Icon(Icons.star, color: Colors.red, size: 16,)
                                    , Icon(Icons.star, color: Colors.red, size: 16,)
                                  ],
                                )
                            ),
*/
                        ],
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              height: 1,
              width: 300.w,
              color: Colors.black26,
            ),
            SizedBox(
              height: 20.h,
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 130.h,
        color: Colors.black12,
        width: MediaQuery.of(context).size.width.w,
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "ITEM TOTAL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Rs. " + widget.orderData.billingamount,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "DELIVERY FEES",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.black26),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Rs. 0",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                            color: Colors.green),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "ITEM TOTAL",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14.sp),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        "Rs. " + widget.orderData.Total,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20.sp),
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
          ],
        ),
      ),
    );
  }
}
