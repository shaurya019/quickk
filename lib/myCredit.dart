import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/DateTimeFormatter.dart';
import 'package:quickk/bloc/WalletBloc/WalletBloc.dart';
import 'package:quickk/modal/WalletData.dart';
import 'package:quickk/repository/WalletRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';


class MyCredit extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => WalletBloc(WalletRepository(Dio())),
        child: MyCreditStateful(),
      ),
    );
  }
}


class MyCreditStateful extends StatefulWidget {


  @override
  _MyCreditStatefulState createState() => _MyCreditStatefulState();
}

class _MyCreditStatefulState extends State<MyCreditStateful> {

  List<WalletData> walletDataList = List.empty(growable: true);
  String walletAmount = "";
  UserDataService userDataService =  getIt<UserDataService>();

  @override
  void initState() {
    super.initState();

    BlocProvider.of<WalletBloc>(context).add(WalletListEvent(context: context,userId: userDataService.userData.customerid));

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: BlocListener<WalletBloc,WalletState>(
        listener: (context,state){
          if(state is WalletCompleteState){
            setState(() {
              walletDataList = state.walletrList;
              walletAmount = state.walletAmount;
            });
          }
        },
        child: SingleChildScrollView(
            child:Stack(
              children: [


                Container(

                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,




                  child:  Column(

                    children: [

                      SizedBox(height: 220.h,),

                   /*   Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [


                          Text("Add Money to Quickk Cash",  style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.sp, fontWeight: FontWeight.bold
                          ), ),
                          Text("How It works",  style: TextStyle(
                              color: Colors.red,
                              fontSize: 15.sp, fontWeight: FontWeight.bold
                          ), ),

                        ],
                      ),


                      SizedBox(height: 10.h,),

                      Card(
                        elevation: 10,

                        child: Container(

                          width: 300.w,
                          height: 150.h,

                          child: Column (
                            children: [

                              SizedBox(height: 20.h),


                              Container(
                                height: 30.h,
                                width: 250.w,
                                padding: EdgeInsets.only(left: 20.w, right: 20.w),

                                decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: BorderRadius.circular(10)
                                ),

                                child:TextField(


                                  decoration: InputDecoration(
                                    hintText: "Enter Amount",
                                    hintMaxLines: 2,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.white),
                                    ),

                                  ),
                                  onChanged: (value) {

                                    var amount = value.toString();
                                  },
                                ),
                              ),
                              SizedBox(height: 20.h),





                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [

                                  Container(
                                    width: 60.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,)
                                        ,borderRadius: BorderRadius.circular(20)
                                    ),

                                    child: Center(
                                      child: Text(
                                          "Rs.250"
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 60.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,)
                                        ,borderRadius: BorderRadius.circular(20)
                                    ),

                                    child: Center(
                                      child: Text(
                                          "Rs.250"
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 60.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,)
                                        ,borderRadius: BorderRadius.circular(20)
                                    ),

                                    child: Center(
                                      child: Text(
                                          "Rs.250"
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 60.w,
                                    height: 25.h,
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.black,)
                                        ,borderRadius: BorderRadius.circular(20)
                                    ),

                                    child: Center(
                                      child: Text(
                                          "Rs.250"
                                      ),
                                    ),
                                  ),






                                ],
                              ),
                              SizedBox(height: 10.h),


                              Container(
                                height: 30.h,
                                width: 250.w,
                                padding: EdgeInsets.only(left: 20.w, right: 20.w),

                                decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10)
                                ),

                                child:Center(
                                  child: Text("Top Up", style:
                                  TextStyle( color: Colors.white),),
                                ),
                              ),



                            ],
                          ),

                        ),


                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)
                        ),
                      ),

                      SizedBox(height: 30.h,),
*/

                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [


                          Text("Recent Activity",  style: TextStyle(
                              color: Colors.black,
                              fontSize: 13.sp, fontWeight: FontWeight.bold
                          ), ),
                          Row(
                            children: [
                              Text("See All",  style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp, fontWeight: FontWeight.bold
                              ), ),

                              Icon(Icons.chevron_right, color: Colors.red,)
                            ],
                          ),



                        ],
                      ),*/

                      Container(
                        width: 300.w,
                        child: ListView.builder(

                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: walletDataList.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  InkWell(
                              onTap: (){
                                //       Navigator.push(context, MaterialPageRoute(builder: (Context)=>OrderDetail()));

                              },
                              child: Container(
                                  width: 300.w,

                                  margin: EdgeInsets.only(bottom: 20.h),


                                  decoration: BoxDecoration(

                                  ),

                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [

                                          Icon(Icons.account_balance_wallet_rounded, size: 25,),

                                          SizedBox(width: 5.w,),

                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(walletDataList[index].remark,  style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13.sp, fontWeight: FontWeight.bold
                                              ), ),

                                              Text(DateFormatter.getDayMonthYearFormat(walletDataList[index].createdon),  style: TextStyle(
                                                  color: Colors.black26,
                                                  fontSize: 13.sp, fontWeight: FontWeight.normal
                                              ), ),

                                            ],
                                          )
                                        ],
                                      ),

                                      Text("Rs. "+walletDataList[index].amount,  style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.sp, fontWeight: FontWeight.bold
                                      ), ),
                                    ],
                                  )

                              ),
                            );



                          },),


                      ),
                    ],
                  ),



                  decoration: BoxDecoration(
                      color: Colors.white
                  ),),



                Container(

                  width: MediaQuery.of(context).size.width,

                  height: 150.h,

                  child: Column(

                    children: [

                      SizedBox(height: 30.h,),

                      Row(

                        children: [

                          GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back_rounded, color: Colors.white,size: 25,),
                          ),

                          Text(" My Credit",  style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp
                          ), )
                        ],
                      )
                    ],
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black87
                  ),


                ),





                Positioned(

                    top: 70.h,
                    left: MediaQuery.of(context).size.width/12,

                    child: Card(
                      elevation: 10,

                      child: Container(

                        width: 300.w,
                        height: 150.h,

                        child: Column (
                          children: [

                            SizedBox(height: 20.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,

                              children: [


                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text("Rs. "+walletAmount,  style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold

                                    ), ),
                                    SizedBox(height: 10.h),

                                    Text("Your Balance",  style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 17.sp,
                                        fontWeight: FontWeight.bold

                                    ), ),


                                  ],
                                ),


                                Image.asset("assets/icon/wallet-3750977-3145186.webp", height: 50.h,)
                              ],
                            ),
                            SizedBox(height: 20.h),

                            Container(
                              height: 1,
                              width: 400,

                              color: Colors.black12,
                            ),

                            SizedBox(height: 10.h),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [

                                Row(
                                  children: [

                                    Image.asset("assets/icon/star1.png", height: 30,),

                                    Text("Redeem Voucher",  style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.bold

                                    ), ),
                                  ],
                                ),

                                Icon(Icons.chevron_right)
                              ],
                            )


                          ],
                        ),

                      ),


                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)
                      ),
                    ))
              ],
            )
        ),
      )
    );
  }
}
