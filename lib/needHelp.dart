import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class NeedHelp extends StatefulWidget {
  const NeedHelp({Key key}) : super(key: key);

  @override
  _NeedHelpState createState() => _NeedHelpState();
}

class _NeedHelpState extends State<NeedHelp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "NEED HELP",
          style: TextStyle(color: Colors.black, fontSize: 14.sp),
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
      ),
      backgroundColor: Colors.white,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "PHONE",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "9810119906",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        size: 30,
                        color: Colors.black54,
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   width: 300.w,
                //   height: 40.h,
                //   decoration: BoxDecoration(
                //       border: Border.all(
                //     color: Colors.black12,
                //   )),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceAround,
                //     children: [
                //       Column(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             "PHONE",
                //             style: TextStyle(
                //                 color: Colors.black,
                //                 fontSize: 12.sp,
                //                 fontWeight: FontWeight.bold),
                //           ),
                //           Text(
                //             "Call Customer Support Now",
                //             style: TextStyle(
                //                 color: Colors.black54, fontSize: 12.sp),
                //           ),
                //         ],
                //       ),
                //       Icon(
                //         Icons.chevron_right,
                //         size: 30,
                //         color: Colors.black54,
                //       )
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 10,
                // ),
                Container(
                  width: 300.w,
                  height: 40.h,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Colors.black12,
                  )),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "EMAIL ID",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "support@quickk.co.in",
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 12.sp),
                            ),
                          ],
                        ),
                        Icon(
                          Icons.chevron_right,
                          size: 30,
                          color: Colors.black54,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Image.asset(
                  "assets/QuickkLogo.png",
                  height: 100.h,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
