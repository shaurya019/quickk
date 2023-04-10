
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/Utils/DataNotAvailable.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/LocationData.dart';
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/savedAdress.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'bloc/AddressBloc/AddressBloc.dart';


class MyAdresses extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => AddressBloc(AddressRepository(Dio())),
        child: MyAdressesStateful(),
      ),
    );
  }
}

class MyAdressesStateful extends StatefulWidget {


  @override
  _MyAdressesStatefulState createState() => _MyAdressesStatefulState();
}

class _MyAdressesStatefulState extends State<MyAdressesStateful> {

  UserDataService userDataService =  getIt<UserDataService>();
  List<LocationData> locationDataList = List.empty(growable: true);
  LocationDataService locationDataService =  getIt<LocationDataService>();
  String locationId = "";
  BuildContext dialogContext;
  bool getData = false;

  @override
  void initState(){
    super.initState();
    if(locationDataService.locationData != null){
      setState(() {
        locationId = locationDataService.locationData.id;
      });
    }
    BlocProvider.of<AddressBloc>(context).add(GetAddressList(context: context,userId:userDataService.userData.customerid));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Addresses", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
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
          Padding(
            padding: EdgeInsets.only(right: 10.w,top: 13.h),
            child: GestureDetector(
              onTap: (){
                //Navigator.push(context, MaterialPageRoute(builder: (Context)=>SavedAdress()));
                Get.to(SavedAdress());
              },
              child: Text("Add", style: TextStyle(color: ColorConstants.primaryColor, fontSize: 16.sp,fontWeight: FontWeight.bold),),
            ),
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: BlocListener<AddressBloc,AddressState>(
          listener: (context,state){
            dialogContext = context;
            if(state is AddressCompleteState){
              setState(() {
                locationId = locationDataService.locationData.id;
                locationDataList = state.locationDataList;
                getData = true;
              });
            }
            if(state is SetAddressCompleteState){
              BlocProvider.of<AddressBloc>(context).add(GetAddressList(context: context,userId:userDataService.userData.customerid));
            }
          },
          child: (getData == true) ? (locationDataList.length > 0) ? ListView.builder(
              itemCount: locationDataList.length,
              itemBuilder: (context,index){
                return GestureDetector(
                  onTap: (){
                    if((locationId != locationDataList[index].id)){
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Change Address',style: TextStyle(color: ColorConstants.primaryColor),),
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
                                            child: Text("Are you sure , you want to use this address.")
                                        ),
                                      ],
                                    )
                                ),
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
                                      textStyle: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                                ElevatedButton(
                                  child: Text('Continue'),
                                  onPressed: () {
                                    Navigator.pop(dialogContext);
                                    BlocProvider.of<AddressBloc>(dialogContext).add(SetCurrentAddressEvent(context: dialogContext,addid:locationDataList[index].id,userid: userDataService.userData.customerid));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: ColorConstants.primaryColor,
                                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                      textStyle: TextStyle(
                                          fontSize: 15.sp,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ],
                            );
                          }
                      );
                    }
                  },
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h,left: 10.w,right: 10.w),
                    child: Container(
                      width: MediaQuery.of(context).size.width.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                        color: (locationId == locationDataList[index].id) ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            width: 0.5
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(width: 10.w,),
                          Image.asset("assets/icons/placeholder.png", height: 30.h,),
                          SizedBox(width: 10.w,),
                          Expanded(child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width.w,
                                //height: 35.h,
                                child: Row(
                                  children: [
                                    Expanded(child:
                                    Text(locationDataList[index].address1+" , "+locationDataList[index].address2, style: TextStyle(color: (locationId == locationDataList[index].id) ? Colors.white : Colors.black, fontSize: 14.sp),),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width.w,
                                //height: 35.h,
                                child: Row(
                                  children: [
                                    Expanded(child: Text(locationDataList[index].pincode+" , "+locationDataList[index].address3, style: TextStyle(color: (locationId == locationDataList[index].id) ? Colors.white : Colors.black, fontSize: 12.sp),),)
                                  ],
                                ),
                              )
                            ],
                          ),)
                        ],
                      ),
                    ),
                  ),
                );
              }
          ) : DataNotAvailable.dataNotAvailable("Orders not Available.") : SizedBox()
      )
    );
  }


}








