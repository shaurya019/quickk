import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';



class DataNotAvailable {


  static Widget dataNotAvailable(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
           Image.asset("assets/datanotfound.png",),
           Text(message ,style: TextStyle(color: Colors.grey,fontSize: 20.sp),)
        ],
      ),
    );
  }



}

