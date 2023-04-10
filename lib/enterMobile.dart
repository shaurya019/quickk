import 'dart:io';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
import 'package:quickk/verifyOtp.dart';
import 'bloc/EnterNumberBloc/EnterNumberBloc.dart';

class EnterMobile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => EnterNumberBloc(EnterNumberRepository(Dio())),
        child: EnterMobileStateful(),
      ),
    );
  }
}

class EnterMobileStateful extends StatefulWidget {
  @override
  _EnterMobileStatefulState createState() => _EnterMobileStatefulState();
}

class _EnterMobileStatefulState extends State<EnterMobileStateful> {
  TextEditingController phoneNumberController = new TextEditingController();
  bool acceptConditions = false;
  bool valuefirst = false;
  String number = '';
  bool PopUp = false;
  double height = 350.h;
  double width = 400;
  double top1 = 400;

  Future<bool> _willPopCallback() async {
    exit(0);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: BlocBuilder<EnterNumberBloc, EnterNumberState>(
          builder: (context, state) {
            return Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Image.asset("assets/90min.png"),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 310.h,
                    child: Stack(
                      children: [
                        Positioned(
                            child: Container(
                                padding: EdgeInsets.only(
                                    left: 30, right: 30, bottom: 30),
                                child: Container(
                                  height: 250.h,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lets get started",
                                        style: TextStyle(
                                          fontSize: 22.sp,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                              height: 50.h,
                                              width: 300.w,
                                              decoration: BoxDecoration(
                                                  color: Color(0xffefefef),
                                                  border: Border.all(
                                                      color: (state.mobileNumber
                                                              .valid)
                                                          ? Colors.black12
                                                          : (state.mobileNumber
                                                                          .value !=
                                                                      "" &&
                                                                  !state
                                                                      .mobileNumber
                                                                      .valid &&
                                                                  state
                                                                          .mobileNumber
                                                                          .value
                                                                          .length >
                                                                      10)
                                                              ? Colors.red
                                                              : Colors.black12,
                                                      width: 1.w),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CountryCodePicker(
                                                    onChanged: print,
                                                    // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
                                                    initialSelection: 'IN',
                                                    favorite: ['+91', 'IN'],
                                                    // optional. Shows only country name and flag
                                                    showCountryOnly: false,
                                                    // optional. Shows only country name and flag when popup is closed.
                                                    showOnlyCountryWhenClosed:
                                                        false,
                                                    // optional. aligns the flag and the Text left
                                                    alignLeft: false,
                                                  ),
                                                  Expanded(
                                                      child: TextFormField(
                                                          inputFormatters: [
                                                        LengthLimitingTextInputFormatter(
                                                            10)
                                                      ],
                                                          controller:
                                                              phoneNumberController,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            hintText:
                                                                "Phone Number",
                                                            errorMaxLines: 1,
                                                            errorText: (state
                                                                    .mobileNumber
                                                                    .valid)
                                                                ? null
                                                                : (state.mobileNumber.value !=
                                                                            "" &&
                                                                        !state
                                                                            .mobileNumber
                                                                            .valid &&
                                                                        state.mobileNumber.value.length >
                                                                            10)
                                                                    ? "Invalid Mobile Number"
                                                                    : null,
                                                            errorStyle:
                                                                TextStyle(
                                                                    color: Colors
                                                                        .red,
                                                                    fontSize:
                                                                        12.sp),
                                                          ),
                                                          keyboardType:
                                                              TextInputType
                                                                  .number,
                                                          onChanged: (value) {
                                                            context
                                                                .read<
                                                                    EnterNumberBloc>()
                                                                .add(MobileNumberChanged(
                                                                    mobileNumber:
                                                                        value));
                                                          })),
                                                ],
                                              )),
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          Text(
                                            "We will send you an otp on this number",
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              color: Colors.black54,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 2.h,
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Container(
                                            height: 30.h,
                                            width: 25.w,
                                            child: Checkbox(
                                              checkColor: Colors.white,
                                              activeColor: Colors.red,
                                              value: acceptConditions,
                                              onChanged: (value) {
                                                setState(() {
                                                  acceptConditions = value;
                                                  if (acceptConditions ==
                                                      false) {
                                                    modalBottomSheet();
                                                  }
                                                });
                                              },
                                            ),
                                          ),
                                          Flexible(
                                              child: Text(
                                            "Agree with the Terms and Condition",
                                            style: TextStyle(fontSize: 12.sp),
                                          )),
                                        ],
                                      ),
                                      SubmitButton()
                                    ],
                                  ),
                                ))),
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        )),
      ),
      onWillPop: _willPopCallback,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    modalBottomSheet();
    /*Future.delayed(Duration(milliseconds: 500 ),()
    {
      if(this.mounted){
        setState(() {
          top1 = 20;
        });
      }
    });PopUp = true;*/
  }

  modalBottomSheet() async {
    await Future.delayed(Duration(milliseconds: 500));
    return showMaterialModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        width: MediaQuery.of(context).size.width,
        height: height,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: Radius.circular(25.w),
            topRight: Radius.circular(25.w),
          ),
        ),
        child: Card(
          margin: EdgeInsets.zero,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(25.w),
                topRight: Radius.circular(25.w)),
          ),
          child: Container(
            height: height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 0.h,
                ),
                Container(
                  height: 50.h,
                  width: 300.w,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                      child: Text(
                    "YOU NEED TO BE ABOVE 18 YEARS OF AGE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Icon(
                      Icons.dangerous,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: Text(
                      "Do not buy tobacco products on behalf of underage persons.",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    )),
                    SizedBox(
                      width: 10.w,
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Icon(
                      Icons.dangerous,
                      color: Colors.red,
                      size: 20,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        child: Text(
                      "Your location must not be in and around school or college premises.",
                      style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold),
                    ))
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 300.w,
                      color: Color(0xfff3f1e5),
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "We strongly advice you against purchasing tobacco if you are a minor or intend to buy on behalf of a minor. we are bound to report your account in case of such transgressions.",
                        style: TextStyle(
                            fontSize: 8.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    Text(
                      "Read T/C",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        fontSize: 15.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    )
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
                          border: Border.all(color: Colors.black, width: 1)),
                      child: Center(
                          child: Text(
                        "No, I'm not",
                        style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      )),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          top1 = 400;
                          acceptConditions = true;
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        height: 40.h,
                        width: 170.w,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Center(
                            child: Text(
                          "Yes, I am above 18",
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10.h,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SubmitButton extends StatefulWidget {
  @override
  SubmitButtonState createState() => SubmitButtonState();
}

class SubmitButtonState extends State<SubmitButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<EnterNumberBloc, EnterNumberState>(
        listener: (context, state) {
          if (state is EnterNumberCompleteState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(VerifyOtp(BlocProvider.of<EnterNumberBloc>(context)
                  .state
                  .mobileNumber
                  .value));
              //Navigator.push(context, MaterialPageRoute(builder: (Context)=>VerifyOtp(BlocProvider.of<EnterNumberBloc>(context).state.mobileNumber.value)));
            });
          }
        },
        child: InkWell(
          onTap: () {
            BlocProvider.of<EnterNumberBloc>(context).add(SendOTPEvent(
                context: context,
                mobileNumber: BlocProvider.of<EnterNumberBloc>(context)
                    .state
                    .mobileNumber
                    .value));
          },
          child: Container(
            height: 50.h,
            width: 300.w,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
                child: Text(
              "Get OTP",
              style: TextStyle(
                  fontSize: 18.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            )),
          ),
        ));
  }
}
