import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/FirebaseMessagingServices.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/splashScreen.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
  setupServiceLocator();
  FirebaseMessagingServices.fireBaseMessageInitialize();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: ColorConstants.primaryColor));
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, widget) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Franticshop',
            /*routes: {
              'homeScreen': (context) => HomeScreen(),kkjj
              'secondScreen': (context) => SecondScreen(),
            },*/
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen(),
          );
        });
  }
}
