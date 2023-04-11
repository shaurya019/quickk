import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:quickk/enterMobile.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/modal/UserData.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:quickk/termsAndCondition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import 'modal/LocationData.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  UserDataService userDataService = getIt<UserDataService>();
  LocationDataService locationDataService = getIt<LocationDataService>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          //backgroundColor: Colors.white,
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                      "assets/Splash.png",
                    ),
                    opacity: 10),
              ), //
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image.asset(
                      "assets/QuickkLogo.png",
                      fit: BoxFit.fitHeight,
                      height: 150,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void initState() {
    super.initState();
    _route();
  }

  void _route() async {
    await Future.delayed(Duration(milliseconds: 3000));
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.getString('userData').toString() == "" ||
        prefs.getString('userData').toString() == "null") {
      // Navigator.push(context, MaterialPageRoute(builder: (Context) => EnterMobile()));
      Get.to(EnterMobile());
    } else {
      Map json = jsonDecode(prefs.getString('userData'));
      UserData userData = UserData.fromJson(json);
      userDataService.setUserdata(userData);
      Map json1 = jsonDecode(prefs.getString('locationData'));
      LocationData locationData = LocationData.fromJson(json1);
      locationDataService.setLocationData(locationData);
      // Navigator.push(context, MaterialPageRoute(builder: (Context) => HomeScreen()));
      Get.to(HomeScreen());
    }
  }
}