// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:quickk/adultVerify.dart';

// class TermsAndConditions extends StatefulWidget {
//   const TermsAndConditions({Key key}) : super(key: key);

//   @override
//   _TermsAndConditionsState createState() => _TermsAndConditionsState();
// }

// class _TermsAndConditionsState extends State<TermsAndConditions> {
//   @override
//   Widget build(BuildContext context) {
//     bool value = false;
//     bool valuefirst = false;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text("Saved Address", style: TextStyle(color: Colors.black, fontSize: 20.sp),),
//         backgroundColor: Colors.white,
//         elevation: 0,
//         titleSpacing: 0,
//         iconTheme: IconThemeData(
//           color: Colors.black, //change your color here
//         ),
//           leading: InkWell(
//     onTap: () {
//     Navigator.pop(context);
//     },
//             child: Icon(
//               Icons.arrow_back,
//               color: Colors.black,
//             ),
//       ),
//     ),



//     body: SingleChildScrollView(
//       child: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Card(
//               elevation: 10,
//               child: Container(

//                 width: 200.w,
//                 margin: EdgeInsets.all(20.w),

//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,

//                   children: [

//                     Text("Terms &",style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold), ),
//                     Text("Condition",style: TextStyle(fontSize: 32.sp, fontWeight: FontWeight.bold), ),
//                     Text("The Customers Agrees that Quickk may use,"
//                       "process and or host customer confidential"
//                       "information/data such as"
//                       "Lorem ipsum dolor sit amet, consectetur"
//                       'adipiscing elit, sed do eiusmod tempor'
//                       'incididunt ut labore et dolore magna aliqua.'
//                       'Quis ipsum suspendisse ultrices gravida.'
//                       'Risus commodo viverra maecenas aLorem'
//                       'ipsum dolor sit amet, consectetur adipiscing'
//                      'elit, sed do eiusmod tempor incididunt ut'
//                       'labore et dolore magna aliqua. Quis ipsum'
//                       'suspendisse ultrices gravida. Risus commodo viverra maecenas accumsan lacus vel Facilisisccumsan lacus vel facilisis.',style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.black54), ),


//                 SizedBox(height:5.h,),
//                 Row(
//                   children: <Widget>[

//                     Container(
//                       height: 30.h,
//                       width: 25.w,
//                       child: Checkbox(

//                         checkColor: Colors.greenAccent,
//                         activeColor: Colors.red,
//                         value: valuefirst,
//                         onChanged: (value) {
//                           setState(() {
//                             valuefirst = value;

//                           });
//                         },
//                       ),
//                     ),
//                     Flexible(child: Text("Agree with the Terms and Condition", style: TextStyle( fontSize: 12.sp),)),
//                   ],
//                 ),


//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.start,
//                       children: <Widget>[

//                         Container(
//                           height: 30.h,
//                           width: 25.w,
//                           child: Checkbox(

//                             checkColor: Colors.greenAccent,
//                             activeColor: Colors.red,
//                             value: valuefirst,
//                             onChanged: (value) {
//                               setState(() {
//                                 valuefirst = value;

//                               });
//                             },
//                           ),
//                         ),
//                         Flexible(child: Text("Agree with the Quickk Privacy Policy",style: TextStyle( fontSize: 12.sp),)),
//                       ],
//                     ),

//                     SizedBox(height:5.h,),


//                     InkWell(
//                       onTap: (){
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         height: 40.h,
//                         width: 110.w,
//                        child: Center(child: Text("Continue", style: TextStyle( fontSize: 14.sp, color: Colors.white),)),

//                         decoration: BoxDecoration(
//                           color: Colors.black,
//                           borderRadius: BorderRadius.circular(10),
//                         ),

//                       ),
//                     )

//                   ],
//                 ),
//               ),

//               shape:  RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),

//             ),
//           ],
//         ),
//       ),
//     ),





//     );
//   }
// }
