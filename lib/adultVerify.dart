import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/enterMobile.dart';

class AdultVerify extends StatefulWidget {
  const AdultVerify({Key key}) : super(key: key);

  @override
  _AdultVerifyState createState() => _AdultVerifyState();
}

class _AdultVerifyState extends State<AdultVerify> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fitWidth,
              alignment: Alignment.topCenter,
              image: AssetImage("assets/mobile.jpg", ),   opacity: 1
          ),
        ),



        child: Column(
          mainAxisAlignment:MainAxisAlignment.end,
          children: [

            Card(

              margin: EdgeInsets.zero,
              elevation: 10,

              shape:  RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight:Radius.circular(20) ),
              ),
child: Container(

  height: 380.h,
  width: MediaQuery.of(context).size.width,

  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [



      Container(
        height: 50.h,
        width: 300.w,

        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(30),

        ),

        child: Center(
          child: Text("YOU NEED TO BE ABOVE 18 YEARS OF AGE", style: TextStyle( fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)
        ),

      ),


      Row(


        mainAxisAlignment: MainAxisAlignment.start,children: [
        SizedBox(
          width: 50.w,
        ),
        Icon(Icons.dangerous, color: Colors.red, size: 20,),
        Text("YOU NEED TO BE ABOVE 18 YEARS OF AGE", style: TextStyle( fontSize: 10.sp, color: Colors.black54, fontWeight: FontWeight.bold),)
      ],),


      Row(mainAxisAlignment: MainAxisAlignment.start,children: [
        SizedBox(
          width: 50.w,
        ),
        Icon(Icons.dangerous, color: Colors.red, size: 20,),
        Text("YOU NEED TO BE ABOVE 18 YEARS OF AGE", style: TextStyle( fontSize: 10.sp, color: Colors.black54, fontWeight: FontWeight.bold),)
      ],),


      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 300.w ,
            color: Color(0xfff3f1e5),

            padding: EdgeInsets.all(4),
            child:  Text("YOU NEED TO BE ABOVE 18 YEARS OF AGE YOU NEED TO BE ABOVE 18 YEARS OF AGE YOU NEED TO BE ABOVE 18 YEARS OF AGE", style: TextStyle( fontSize: 8.sp, color: Colors.black54, fontWeight: FontWeight.bold),)
            ,
          ),

          SizedBox(
            height: 30.h,
          ),

          Text("Read T/C", style: TextStyle( decoration:TextDecoration.underline,fontSize: 15.sp, color: Colors.black, fontWeight: FontWeight.bold, ),)

        ],
      ),


      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            height: 40.h,
            width: 100.w,

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.black, width: 1)

            ),

            child: Center(
                child: Text("No, I'm not", style: TextStyle( fontSize: 14.sp, color: Colors.black, fontWeight: FontWeight.bold),)
            ),

          ),
          InkWell(
            onTap: (){
              Get.to(EnterMobile());
              //Navigator.push(context, MaterialPageRoute(builder: (Context)=>EnterMobile()));
            },
            child: Container(
              height: 40.h,
              width: 170.w,

              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(30),

              ),

              child: Center(
                  child: Text("Yes, I am above 18", style: TextStyle( fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),)
              ),

            ),
          ),
        ],
      ),



    ],
  ),

),

            ),
          ],
        ),
      ),
    );
  }
}
