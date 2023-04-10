import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/MyAddresses.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'bloc/AddressBloc/AddressBloc.dart';


class SavedAdress extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: BlocProvider(
        create: (_) => AddressBloc(AddressRepository(Dio())),
        child: SavedAdressStateful(),
      ),
    );
  }
}

class SavedAdressStateful extends StatefulWidget {
  const SavedAdressStateful({Key key}) : super(key: key);

  @override
  _SavedAdressState createState() => _SavedAdressState();
}

class _SavedAdressState extends State<SavedAdressStateful> {



  String _radioSelected = "Home";
  String _radioVal;

  TextEditingController address1 = new TextEditingController(text: "");
  TextEditingController address2 = new TextEditingController(text: "");
  TextEditingController address3 = new TextEditingController(text: "");
  TextEditingController pincode = new TextEditingController(text: "");
  UserDataService userDataService =  getIt<UserDataService>();

  static double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter Address Details", style: TextStyle(color: Colors.black, fontSize: 16.sp),),
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
      body: BlocListener<AddressBloc,AddressState>(
        listener: (context,state){
          if(state is AddressCompleteState){
            WidgetsBinding.instance.addPostFrameCallback((_){
              Get.to(MyAdresses());
              //Navigator.push(context, MaterialPageRoute(builder: (Context) => MyAdresses()));
            });
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.black38,
              ),
              SizedBox(height: 30.h,),
              Container(
                width: 270.w,
                child: Row(
                  children: [
                    Text("House No. & Floor & Building & Bloc No.", style: TextStyle(color: Colors.black45, fontSize: 14.sp),),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                child: Container(
                    width: 300.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(child: TextField(
                          controller: address1,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                          ),
                          onChanged: (value) {

                            var number = value.toString();
                          },
                        ),),




                      ],
                    )
                ),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Container(
                width: 270.w,
                child: Row(
                  children: [
                    Text("Pincode*", style: TextStyle(color: Colors.black45, fontSize: 14.sp),),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                child: Container(
                    width: 300.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(child: TextField(
                          controller: pincode,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                          ),
                          onChanged: (value) {

                            var number = value.toString();
                          },
                        ),),




                      ],
                    )
                ),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              Container(
                width: 270.w,
                child: Row(
                  children: [
                    Text("City*", style: TextStyle(color: Colors.black45, fontSize: 14.sp),),
                  ],
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              Card(
                child: Container(
                    width: 300.w,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 10.w,
                        ),
                        Expanded(child: TextField(
                          controller: address2,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                          ),
                          onChanged: (value) {

                            var number = value.toString();
                          },
                        ),),




                      ],
                    )
                ),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
              ),
              SizedBox(
                height: 20.h,
              ),

              Container(
                width: 270.w,
                child: Row(
                  children: [
                    Text("State*", style: TextStyle(color: Colors.black45, fontSize: 14.sp),),
                  ],
                ),
              ),

              SizedBox(
                height: 10.h,
              ),
              Card(



                child: Container(
                    width: 300.w,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [



                        SizedBox(
                          width: 10.w,
                        ),

                        Expanded(child: TextField(
                          controller: address3,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: "",
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),

                          ),
                          onChanged: (value) {

                            var number = value.toString();
                          },
                        ),),




                      ],
                    )
                ),
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),

                ),
              ),

              SizedBox(
                height: 10.h,
              ),


              Row(
                children: <Widget>[
                  SizedBox(width: 10.w,),
                  Expanded(
                    flex:1,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: const Text('Home',style: TextStyle(

                      ),
                      ),
                      leading: Radio(
                        value: 'Home',
                        groupValue: _radioSelected,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = 'Home';
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: const Text('Work'),
                      leading: Radio(
                        value: 'Work',
                        groupValue: _radioSelected,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = 'Work';
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex:1,
                    child: ListTile(
                      horizontalTitleGap: 0,
                      title: const Text('Other'),
                      leading: Radio(
                        value: 'Other',
                        groupValue: _radioSelected,
                        activeColor: ColorConstants.primaryColor,
                        onChanged: (value) {
                          setState(() {
                            _radioSelected = value;
                            _radioVal = 'Other';
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(width: 10.w,),
                ],
              ),


              SizedBox(height: 50.h,),

              InkWell(
                onTap: (){
                  BlocProvider.of<AddressBloc>(context).add(SaveAddressEvent(context: context,address1: address1.text,address2:address2.text,address3:address3.text,pincode:pincode.text,latitude: "" ,longitude: "",userid: userDataService.userData.customerid));
                },
                child: Container(
                  height: 40.h,
                  width:300.w,
                  child: Center(child: Text("SAVE & CONTINUE", style: TextStyle( fontSize: 14.sp, color: Colors.white),)),

                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(10),
                  ),

                ),
              ),


            ],
          ),
        ),
      )
    );
  }


}


