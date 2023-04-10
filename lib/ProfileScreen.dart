import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:quickk/BottomNavigationWidget.dart';
import 'package:quickk/EditProfile.dart';
import 'package:quickk/MyAddresses.dart';
import 'package:quickk/aboutUs.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/contact.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/myCredit.dart';
import 'package:quickk/needHelp.dart';
import 'package:quickk/orderScreen.dart';
import 'package:quickk/provider/profile.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/savedAdress.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:quickk/splashScreen.dart';
import 'package:quickk/termsAndCondition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:location/location.dart';
import 'package:quickk/BottomNavigationWidget.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;

import 'provider/HomeScreenProvider.dart';
import 'tandc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserDataService userDataService = getIt<UserDataService>();
  SharedPreferences prefs;
  String address = "";

  HomeScreenRepository repository;
  Dio client;
  LocationDataService locationDataService = getIt<LocationDataService>();

  @override
  void initState() {
    super.initState();
    getSharedPreference();
    getUserLocation();

    print(
        "userDataService===>>>" + userDataService.userData.toJson().toString());
  }

  void getSharedPreference() async {
    prefs = await SharedPreferences.getInstance();
  }

  getUserLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    //_locationData = await location.getLocation();
    /*var latitude = _locationData.latitude.toString();
    var longitude = _locationData.longitude.toString();*/
    geolocator.Position currentLocation = await locateUser();
    setState(() {});
    var latitude = currentLocation.latitude.toString();
    var longitude = currentLocation.longitude.toString();
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
            double.parse(latitude.toString()),
            double.parse(longitude.toString()));
    //String address = placemarks[0].name + "," + placemarks[0].street +"," +placemarks[0].locality+","+placemarks[0].administrativeArea+","+placemarks[0].country+","+placemarks[0].postalCode;

    setState(() {
      address = placemarks[0].name +
          "," +
          placemarks[0].street +
          "," +
          placemarks[0].locality +
          "," +
          placemarks[0].administrativeArea +
          "," +
          placemarks[0].country +
          "," +
          placemarks[0].postalCode;
    });
  }

  Future<geolocator.Position> locateUser() async {
    return Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
  }

  Future<bool> _willPopCallback() async {
    Get.to(HomeScreen());
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 300,
                      decoration: BoxDecoration(color: Colors.black12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10.w),
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Get.to(HomeScreen());
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      "Profile",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 20),
                                    )
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 0.w),
                                child: InkWell(
                                  onTap: () {
                                    //Navigator.push(context, MaterialPageRoute(builder: (Context)=>EditProfile()));
                                    Get.to(EditProfile());
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 30,
                                    decoration: BoxDecoration(),
                                    child: Center(
                                      child: Text(
                                        "EDIT",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          CircleAvatar(
                            radius: 48,
                            backgroundColor: Colors.white,
                            child: CircleAvatar(
                              radius: 44,
                              backgroundColor: Colors.blue,
                              child: CircleAvatar(
                                radius: 40.0,
                                backgroundImage: NetworkImage(
                                  "https://cdn.pixabay.com/photo/2019/02/22/17/04/man-4013984_1280.png",
                                ),
                                backgroundColor: Colors.transparent,
                              ),
                            ),
                          ),
                          Text(
                            userDataService.userData.firstname.toString() +
                                " " +
                                userDataService.userData.lastname.toString(),
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Container(
                                  height: 50,
                                  width: MediaQuery.of(context).size.width.w,
                                  margin:
                                      EdgeInsets.only(left: 30.w, right: 30.w),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.only(top: 5.h, bottom: 5.h),
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                        Image.asset(
                                          "assets/icons/placeholder.png",
                                          height: 20.h,
                                        ),
                                        SizedBox(
                                          width: 5.w,
                                        ),
                                        Expanded(
                                          child: Text(
                                            address,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            Get.to(MyAdresses());
                                            //Navigator.push(context, MaterialPageRoute(builder: (Context)=>MyAdresses()));
                                          },
                                          child: Text(
                                            "CHANGE",
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 10.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10.w,
                                        ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(OrderScreen());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>OrderScreen()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/order.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "My Orders",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(NeedHelp());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>NeedHelp()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/help.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "NEED HELP? REACH OUT TO US",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(MyCredit());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>MyCredit()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/wallet-passes-app.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "QUICKK CASH/REWARDS",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(AboutUs());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>AboutUs()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/working.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "ABOUT US",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(Contact());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>AboutUs()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Icon(
                              Icons.contact_support,
                              size: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "CONTACT US",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icons/placeholder.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Expanded(
                              child: Text(
                                "MY ADDRESSES",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(MyAdresses());
                                //Navigator.push(context, MaterialPageRoute(builder: (Context)=>MyAdresses()));
                              },
                              child: Text(
                                "VIEW",
                                style: TextStyle(
                                    color: ColorConstants.primaryColor,
                                    decoration: TextDecoration.underline,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(right: 20)),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        Get.to(Term());
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>TermsAndConditions()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/agreement.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "TERMS & CONDITION",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        //     Navigator.push(context, MaterialPageRoute(builder: (Context)=>TermsAndCondition()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Icon(Icons.handshake),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "SHARE IT",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    InkWell(
                      onTap: () {
                        //     Navigator.push(context, MaterialPageRoute(builder: (Context)=>GetOtp()));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 12, left: 15, bottom: 12),
                        child: Row(
                          children: [
                            Image.asset(
                              "assets/icon/reminder.png",
                              height: 20,
                            ),
                            Padding(padding: EdgeInsets.only(left: 20)),
                            Text(
                              "NOTIFICATION",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 1,
                      color: Colors.black,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    InkWell(
                      onTap: () {
                        prefs.setString('userData', "");
                        //userDataService.setUserdata(null);
                        //Navigator.push(context, MaterialPageRoute(builder: (Context)=>SplashScreen()));
                        Get.to(SplashScreen());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Text(
                            "Log Out",
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    )
                  ],
                ),
              ),
            ),
          ),
          bottomNavigationBar: BottomNavigationWidget(3)),
    );
  }
}
