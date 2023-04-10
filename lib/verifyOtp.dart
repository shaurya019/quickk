import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:quickk/bloc/EnterNumberBloc/EnterNumberBloc.dart';
import 'package:quickk/bloc/OTPVerificationBloc/OTPVerificationBloc.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/profileDetail.dart';
import 'package:quickk/repository/EnterNumberRepository.dart';
import 'package:quickk/repository/OTPVerificationRepository.dart';

class VerifyOtp extends StatelessWidget {
  String mobileNumber;

  VerifyOtp(String _value) {
    mobileNumber = _value;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => OTPVerificationBloc(OTPVerificationRepository(Dio())),
        child: VerifyOtpStateful(mobileNumber),
      ),
    );
  }
}

class VerifyOtpStateful extends StatefulWidget {
  String mobileNumber;

  VerifyOtpStateful(String _value) {
    mobileNumber = _value;
  }

  @override
  _VerifyOtpState createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtpStateful> {
  TextEditingController otpController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "OTP",
          style: TextStyle(color: Colors.black, fontSize: 20.sp),
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
          SizedBox(
            height: 40.h,
            child: Image.asset(
              "assets/QuickkLogo.png",
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
          child: BlocListener<OTPVerificationBloc, OTPVerificationState>(
              listener: (context, state) {
                if (state is OTPVerificationCompleteState) {
                  if (state.isRegistered) {
                    print('hh');
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      //Navigator.push(context, MaterialPageRoute(builder: (Context) => HomeScreen()));
                      Get.to(HomeScreen());
                    });
                  } else {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print('hh');
                      Get.to(ProfileDetail(widget.mobileNumber));
                      //Navigator.push(context, MaterialPageRoute(builder: (Context) => ProfileDetail(widget.mobileNumber)));
                    });
                  }
                }
              },
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height - 100.h,
                padding: EdgeInsets.only(left: 30.w, right: 30.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "OTP",
                              style: TextStyle(
                                fontSize: 34.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Verification",
                              style: TextStyle(
                                fontSize: 34.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Text(
                              "Otp have been sent to the number",
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.black54,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      width: 240,
                      child: PinCodeTextField(
                        appContext: context,
                        controller: otpController,
                        pastedTextStyle: TextStyle(
                          color: Colors.green.shade600,
                          fontWeight: FontWeight.bold,
                        ),
                        length: 4,
                        obscureText: false,

                        blinkWhenObscuring: true,
                        animationType: AnimationType.fade,
                        validator: (v) {
                          if (v.length < 4) {
                            return "";
                          } else {
                            return "";
                          }
                        },
                        pinTheme: PinTheme(
                            shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(5),
                            fieldHeight: 50,
                            fieldWidth: 40,
                            activeFillColor: Colors.white,
                            activeColor: Colors.white,
                            selectedColor: Colors.grey,
                            selectedFillColor: Colors.white,
                            inactiveColor: Colors.white,
                            inactiveFillColor: Colors.white),
                        cursorColor: Colors.black,
                        animationDuration: Duration(milliseconds: 300),
                        enableActiveFill: true,

                        keyboardType: TextInputType.number,
                        boxShadows: [
                          BoxShadow(
                            offset: Offset(0, 1),
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                        onCompleted: (v) {
                          print("Completed");
                        },
                        // onTap: () {
                        //   print("Pressed");
                        // },
                        onChanged: (value) {
                          print(value);
                          setState(() {});
                        },
                        beforeTextPaste: (text) {
                          print("Allowing to paste $text");
                          //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                          //but you can show anything you want here, like your pop up saying wrong paste format or etc
                          return true;
                        },
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        BlocProvider.of<OTPVerificationBloc>(context).add(
                            VerifyOTPEvent(
                                context: context,
                                mobileNumber: widget.mobileNumber,
                                otpNumber: otpController.text));
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
                          "Send OTP",
                          style: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        "00:" + timeForOtp.toString(),
                        style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Text(
                        "Didn't get it?",
                        style: TextStyle(
                            fontSize: 20.sp,
                            color: Colors.black54,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.lock,
                              color: Colors.deepOrange,
                            ),
                            Text(
                              "Send OTP(SMS)",
                              style: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.call,
                                color: Colors.deepPurple,
                              ),
                              Text(
                                "Call me with otp",
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ))),
    );
  }

  int timeForOtp = 60;

  Timer timer;

  void startCount() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (this.mounted) {
        setState(() {
          if (timeForOtp > 0) {
            timeForOtp--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  bool PopUp = true;

  @override
  void initState() {
    super.initState();
    startCount();
  }

  void runNext() {}
}
