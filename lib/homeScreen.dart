import 'dart:io';

import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:quickk/BottomNavigationWidget.dart';
import 'package:quickk/CategoriesToExplore.dart';
import 'package:quickk/PendingApproval.dart';
import 'package:quickk/RecommendedProducts.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/Wishlist.dart';
import 'package:quickk/bloc/HomeScreenBloc/HomeScreenBloc.dart';
import 'package:quickk/bloc/ProductBloc/ProductBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/CategoryData.dart';
import 'package:quickk/modal/OfferData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/modal/SliderData.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/productScreen.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/LocationService.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';
import 'package:quickk/shopingCart.dart';

import 'Utils/DialogUtils/DialogUtil.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductBloc(ProductRepository(Dio())),
        ),
        BlocProvider(
          create: (context) => HomeScreenBloc(HomeScreenRepository(Dio())),
        ),
      ],
      child: HomeScreenStateful(),
    ));
  }
}

class HomeScreenStateful extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreenStateful> {
  List<CategoryData> categoryDataList = List.empty(growable: true);
  List<ProductData> topProductDataList = List.empty(growable: true);
  List<OfferData> offerDataList = List.empty(growable: true);
  List<SliderData> sliderDataList = List.empty(growable: true);
  List<ProductData> recomProductDataList = List.empty(growable: true);
  String address = "";
  LocationDataService locationDataService = getIt<LocationDataService>();
  int _current = 0;
  UserDataService userDataService = getIt<UserDataService>();
  List<CartData> cartDataList = List.empty(growable: true);
  int backIndex = 0;
  double sellingPrice = 0.0;
  bool loading = false;
  double orignalPrice = 0.0;
  int qty = 0;
  BuildContext homeBlocContext, productBlocContext;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<HomeScreenBloc>(context)
        .add(GetCategoryList(context: context));
    BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<HomeScreenBloc>(context)
        .add(HomeSliderList(context: context));
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<HomeScreenBloc>(context).add(GetUserData(
        context: context, userId: userDataService.userData.customerid));
    getUserLocation();
  }

  getdata() {
    BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(
        context: context, userId: userDataService.userData.customerid));
    BlocProvider.of<HomeScreenBloc>(context)
        .add(HomeSliderList(context: context));
    BlocProvider.of<ProductBloc>(context).add(FetchCartList(
        context: context, userId: userDataService.userData.customerid));
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
    if (backIndex < 2) {
      backIndex++;
      Fluttertoast.showToast(
          msg: "Please Press again to exit from app.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey,
          textColor: Colors.white,
          fontSize: 16.0);
      return Future.value(false);
    } else {
      exit(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _willPopCallback,
      child: SafeArea(
          child: Scaffold(
              backgroundColor: Colors.white,
              body: ListView(
                shrinkWrap: true,
                children: [
                  BlocListener<HomeScreenBloc, HomeScreenState>(
                    listener: (context, state) {
                      if (state is HomeScreenCompleteState) {
                        setState(() {
                          //homeBlocContext = context;
                          categoryDataList = state.categoryDataList;
                        });
                      }
                      if (state is HomeDataListCompleteState) {
                        setState(() {
                          topProductDataList = state.topProductDataList;
                          offerDataList = state.offerDataList;
                          recomProductDataList = state.recomProductDataList;
                          print(topProductDataList[0].b2bprice.toString() +
                              "manoj");
                        });
                      }
                      if (state is HomeSliderCompleteState) {
                        setState(() {
                          sliderDataList = state.sliderDataList;
                        });
                      }
                      if (state is GetUserDataCompleteState) {
                        setState(() {
                          userDataService = getIt<UserDataService>();
                          print("userDataService===>>>" +
                              userDataService.userData.toJson().toString());
                          if (userDataService.userData.isapproved.toString() ==
                                  "0" &&
                              userDataService.userData.usertype.toString() ==
                                  "2") {
                            Get.to(PendingApproval());
                          }
                        });
                      }
                    },
                    child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      //mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        BlocListener<ProductBloc, ProductState>(
                            listener: (context, state) {
                              if (state is CartDataCompleteState) {
                                setState(() {
                                  //productBlocContext = context;
                                  cartDataList = state.cartDataList;
                                });
                              } else if (state is AddtoCartCompleteState) {
                                setState(() {
                                  BlocProvider.of<HomeScreenBloc>(context).add(
                                      HomeDataList(
                                          context: context,
                                          userId: userDataService
                                              .userData.customerid));
                                  BlocProvider.of<ProductBloc>(context).add(
                                      FetchCartList(
                                          context: context,
                                          userId: userDataService
                                              .userData.customerid));
                                });
                              } else if (state is EditCartListCompleteState) {
                                BlocProvider.of<HomeScreenBloc>(context).add(
                                    HomeDataList(
                                        context: context,
                                        userId: userDataService
                                            .userData.customerid));
                              } else if (state is AddtoWishListCompleteState) {
                                BlocProvider.of<HomeScreenBloc>(context).add(
                                    HomeDataList(
                                        context: context,
                                        userId: userDataService
                                            .userData.customerid));
                              } else if (state
                                  is DeleteFromWishListCompleteState) {
                                BlocProvider.of<HomeScreenBloc>(context).add(
                                    HomeDataList(
                                        context: context,
                                        userId: userDataService
                                            .userData.customerid));
                              }
                            },
                            child: SizedBox()),
                        Container(
                          height: 40,
                          margin: EdgeInsets.only(
                              left: 10.w, right: 10.h, bottom: 5.h),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: 30,
                                        color: Colors.amberAccent,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        child: Text(
                                          address.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12.sp),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Icon(
                                  Icons.notifications_active,
                                  size: 25,
                                  color: Colors.amberAccent,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Get.to(ShopingCart())
                                          .then((value) => getdata());
                                      //Navigator.push(context, MaterialPageRoute(builder: (Context)=>ShopingCart()));
                                    },
                                    child: Badge(
                                      badgeContent: (cartDataList != null)
                                          ? Text(
                                              cartDataList.length.toString(),
                                              style: TextStyle(fontSize: 10.sp),
                                            )
                                          : Text(
                                              "0",
                                              style: TextStyle(fontSize: 10.sp),
                                            ),
                                      child: Icon(
                                        Icons.shopping_cart,
                                        color: Colors.green,
                                        size: 30,
                                      ),
                                    ))
                              ]),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width.w,
                          height: 1.h,
                          color: Colors.black26,
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 150.h,
                            aspectRatio: 9 / 9,
                            viewportFraction: 1.0,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _current = index;
                              });
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: sliderDataList.map((sliderData) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  margin: EdgeInsets.only(
                                      left: 5.w, right: 5.w, top: 5.h),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                        ApiConstants.IMAGE_URL +
                                            sliderData.imgurl,
                                        fit: BoxFit.cover,
                                        height: 150.h,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width
                                            .w),
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: sliderDataList.map(
                            (image) {
                              int index = sliderDataList.indexOf(image);
                              return Container(
                                width: 8.0,
                                height: 8.0,
                                margin: EdgeInsets.symmetric(
                                    vertical: 5.h, horizontal: 2.w),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? Color.fromRGBO(0, 0, 0, 0.9)
                                        : Color.fromRGBO(0, 0, 0, 0.4)),
                              );
                            },
                          ).toList(),
                        ),
                        Column(
                          //crossAxisAlignment: CrossAxisAlignment.start,
                          //mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width:
                                          MediaQuery.of(context).size.width.w /
                                              2.w,
                                      //color: ColorConstants.backGroundColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  top: 0.h),
                                              child: Text(
                                                "CATEGORY",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                              ],
                            ),
                            SizedBox(height: 0.h),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 10.w, right: 10.w, top: 10.h),
                              child: GridView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          // childAspectRatio:
                                          //     MediaQuery.of(context)
                                          //             .size
                                          //             .width /
                                          //         (MediaQuery.of(context)
                                          //                 .size
                                          //                 .height /
                                          //             1.4),
                                          // childAspectRatio: 1 / 1.2,
                                          crossAxisSpacing: 0,
                                          mainAxisSpacing: 0,
                                          crossAxisCount: 3),
                                  itemCount: categoryDataList.length,
                                  itemBuilder: (BuildContext ctx, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        Get.to(ProductScreen(
                                            categoryDataList[index]
                                                .id
                                                .toString()));
                                        //Navigator.push(context, MaterialPageRoute(builder: (Context) => ProductScreen(categoryDataList[index].id.toString())));
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          // width: 100,
                                          // height: 80.h,
                                          decoration: BoxDecoration(
                                              color: Colors.grey[200],
                                              border: Border.all(
                                                  color: Colors.black12,
                                                  width: 0.2),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              (categoryDataList[index].imgurl !=
                                                          null &&
                                                      categoryDataList[index]
                                                              .imgurl !=
                                                          "")
                                                  ? ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.only(
                                                              topLeft: Radius
                                                                  .circular(10),
                                                              topRight: Radius
                                                                  .circular(
                                                                      10)),
                                                      child: Image.network(
                                                        ApiConstants.IMAGE_URL +
                                                            categoryDataList[
                                                                    index]
                                                                .imgurl,
                                                        fit: BoxFit.fill,
                                                        height: 70.h,
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width
                                                            .w,
                                                      ))
                                                  : SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                              .size
                                                              .width
                                                              .w,
                                                      height: 70.h,
                                                    ),
                                              SizedBox(
                                                height: 4.h,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  categoryDataList[index].name,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            ),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width:
                                          MediaQuery.of(context).size.width.w /
                                              2.w,
                                      //color: ColorConstants.primaryColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  top: 0.h),
                                              child: Text(
                                                "OFFERS",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(CategoriesToExplore("offer"));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.w, right: 12.w, top: 0.h),
                                    child: Text(
                                      "SHOW MORE",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorConstants.backGroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, right: 10.w, top: 10.h),
                                child: Container(
                                  height: 90.h,
                                  margin:
                                      EdgeInsets.only(top: 5.w, bottom: 5.h),
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: offerDataList.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(ProductScreen(
                                                offerDataList[index]
                                                    .categoryid
                                                    .toString()));
                                            //Navigator.push(context, MaterialPageRoute(builder: (Context) => ProductScreen(categoryDataList[index].id.toString())));
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width
                                                    .w /
                                                3.5.w,
                                            height: 90.h,
                                            margin: EdgeInsets.only(right: 5.w),
                                            decoration: BoxDecoration(
                                                color: Colors.grey[200],
                                                border: Border.all(
                                                    color: Colors.black12,
                                                    width: 0.2),
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                (offerDataList[index].imgurl !=
                                                            null &&
                                                        offerDataList[index]
                                                                .imgurl !=
                                                            "")
                                                    ? ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        10),
                                                                topRight: Radius
                                                                    .circular(
                                                                        10)),
                                                        child: Image.network(
                                                          ApiConstants
                                                                  .IMAGE_URL +
                                                              offerDataList[
                                                                      index]
                                                                  .imgurl,
                                                          fit: BoxFit.fill,
                                                          height: 70.h,
                                                          width: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .width
                                                              .w,
                                                        ))
                                                    : SizedBox(
                                                        width: MediaQuery.of(
                                                                context)
                                                            .size
                                                            .width
                                                            .w,
                                                        height: 70.h,
                                                      ),
                                                SizedBox(
                                                  height: 4.h,
                                                ),
                                                Text(
                                                  offerDataList[index]
                                                      .category
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )),
                            SizedBox(height: 10.h),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width:
                                          MediaQuery.of(context).size.width.w /
                                              2.0.w,
                                      //color: ColorConstants.primaryColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  top: 0.h),
                                              child: Text(
                                                "NEW ARRIVALS",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(CategoriesToExplore("newArrivals"));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.w, right: 12.w, top: 0.h),
                                    child: Text(
                                      "SHOW MORE",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorConstants.backGroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, right: 10.w, top: 10.h),
                                child: Container(
                                  height: 210.h,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topProductDataList.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        sellingPrice = 0.0;
                                        orignalPrice = 0.0;
                                        print(topProductDataList[index]
                                                .mrp
                                                .toString() +
                                            'mrp');
                                        if (userDataService.userData.usertype ==
                                            "1") {
                                          orignalPrice = double.parse(
                                              topProductDataList[index]
                                                  .mrp
                                                  .toString());
                                          print(topProductDataList[index]
                                                  .qty
                                                  .toString() +
                                              'mmm');
                                          sellingPrice = double.parse(
                                              topProductDataList[index]
                                                  .b2cselprice
                                                  .toString());
                                        } else if (userDataService
                                                .userData.usertype ==
                                            "2") {
                                          orignalPrice = double.parse(
                                              topProductDataList[index]
                                                  .mrp
                                                  .toString());
                                          print(
                                              orignalPrice.toString() + 'mmm');
                                          sellingPrice = double.parse(
                                              topProductDataList[index]
                                                  .b2bselprice
                                                  .toString());
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(ProductDescription(
                                                topProductDataList[index]
                                                    .productid));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                bottom: 10.h, right: 10.w),
                                            //height: 280.h,
                                            width: 150.w,
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100.h,
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 0.w,
                                                                  top: 0.h),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15.w),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12.w),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15.w),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12.w),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3.w,
                                                                        right:
                                                                            3.w,
                                                                        top: 3
                                                                            .h),
                                                                child: Image
                                                                    .network(
                                                                  ApiConstants
                                                                          .IMAGE_URL +
                                                                      topProductDataList[
                                                                              index]
                                                                          .imgurl,
                                                                  height: 100.h,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width
                                                                      .w,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ))),
                                                      // Align(
                                                      //     alignment: Alignment
                                                      //         .topRight,
                                                      //     child: Padding(
                                                      //       padding:
                                                      //           EdgeInsets.only(
                                                      //               right: 2.w,
                                                      //               top: 2.h),
                                                      //       child: (topProductDataList[index]
                                                      //                       .wishlist !=
                                                      //                   null &&
                                                      //               topProductDataList[index]
                                                      //                       .wishlist !=
                                                      //                   "")
                                                      //           ? GestureDetector(
                                                      //               onTap: () {
                                                      //                 BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                                      //                     context:
                                                      //                         context,
                                                      //                     wishListId: topProductDataList[index]
                                                      //                         .wishlist,
                                                      //                     productDataList:
                                                      //                         topProductDataList,
                                                      //                     currentIndex:
                                                      //                         index));
                                                      //               },
                                                      //               child: Icon(
                                                      //                 Icons
                                                      //                     .favorite,
                                                      //                 color: Colors
                                                      //                     .redAccent,
                                                      //                 size:
                                                      //                     30.sp,
                                                      //               ),
                                                      //             )
                                                      //           : GestureDetector(
                                                      //               onTap: () {
                                                      //                 BlocProvider.of<ProductBloc>(context).add(AddtoWishlist(
                                                      //                     context:
                                                      //                         context,
                                                      //                     productId: topProductDataList[index]
                                                      //                         .productid,
                                                      //                     userId: userDataService
                                                      //                         .userData
                                                      //                         .customerid,
                                                      //                     userType: userDataService
                                                      //                         .userData
                                                      //                         .usertype,
                                                      //                     productDataList:
                                                      //                         topProductDataList,
                                                      //                     currentIndex:
                                                      //                         index));
                                                      //               },
                                                      //               child: Icon(
                                                      //                 Icons
                                                      //                     .favorite_outline_rounded,
                                                      //                 color: Colors
                                                      //                     .redAccent,
                                                      //                 size:
                                                      //                     30.sp,
                                                      //               ),
                                                      //             ),
                                                      //     )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  // color: Colors.white,
                                                  height: 100.h,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              topProductDataList[
                                                                      index]
                                                                  .name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              maxLines: 3,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),

                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "₹" +
                                                                sellingPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    15.sp),
                                                          ),
                                                          SizedBox(
                                                            width: 5.h,
                                                          ),
                                                          Text(
                                                            "₹" +
                                                                orignalPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    13.sp),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {},
                                                              child: (topProductDataList[index]
                                                                              .cartlist !=
                                                                          null &&
                                                                      topProductDataList[index]
                                                                              .cartlist !=
                                                                          "")
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              loading = true;
                                                                              if (int.parse(topProductDataList[index].qty) > 0) {
                                                                                qty = int.parse(topProductDataList[index].qty);
                                                                                qty = qty - 1;
                                                                                BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: topProductDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item quantity can not lesser than 0.")));
                                                                                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                              }
                                                                              loading = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                24.h,
                                                                            width:
                                                                                24.w,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "-",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.w,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              24.h,
                                                                          width:
                                                                              24.w,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white70,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(color: Colors.black26, width: 1)),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              topProductDataList[index].qty.toString(),
                                                                              style: TextStyle(color: Colors.black, fontSize: 18.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.w,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              // loading = true;
                                                                              if (loading == false) {
                                                                                // DialogUtil.showProgressDialog("", context);
                                                                                qty = int.parse(topProductDataList[index].qty);
                                                                                qty = qty + 1;
                                                                                BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: topProductDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                              } else {}
                                                                              // loading = false;
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                24.h,
                                                                            width:
                                                                                24.w,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black54,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "+",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        BlocProvider.of<ProductBloc>(context).add(AddToCartEvent(
                                                                            context:
                                                                                context,
                                                                            productId: topProductDataList[index]
                                                                                .productid
                                                                                .toString(),
                                                                            userId: userDataService
                                                                                .userData.customerid,
                                                                            userType: userDataService
                                                                                .userData.usertype,
                                                                            productDataList:
                                                                                topProductDataList,
                                                                            currentIndex:
                                                                                index));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30.h,
                                                                        width:
                                                                            80.w,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "ADD",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                        ],
                                                      ),

                                                      // SizedBox(
                                                      //   height: 5.h,
                                                      // ),
                                                      // Row(
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment
                                                      //           .center,
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .center,
                                                      //   children: [
                                                      //     Text(
                                                      //       "₹" +
                                                      //           sellingPrice
                                                      //               .toString(),
                                                      //       style: TextStyle(
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //           fontSize:
                                                      //               14.sp),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )),
                            SizedBox(height: 0.h),
                            Row(
                              children: [
                                Expanded(
                                    child: Row(
                                  children: [
                                    Container(
                                      height: 30.h,
                                      width:
                                          MediaQuery.of(context).size.width.w /
                                              1.5.w,
                                      //color: ColorConstants.primaryColor,
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 12.w,
                                                  right: 12.w,
                                                  top: 0.h),
                                              child: Text(
                                                "MORE TOP PICKS FOR YOU",
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    color: ColorConstants
                                                        .primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15.sp),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                )),
                                GestureDetector(
                                  onTap: () {
                                    Get.to(CategoriesToExplore("morepick"));
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        left: 0.w, right: 12.w, top: 0.h),
                                    child: Text(
                                      "SHOW MORE",
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                          color: ColorConstants.backGroundColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.sp),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 10.w, right: 10.w, top: 10.h),
                                child: Container(
                                  height: 205.h,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: recomProductDataList.length,
                                      itemBuilder: (BuildContext ctx, index) {
                                        sellingPrice = 0.0;
                                        orignalPrice = 0.0;
                                        if (userDataService.userData.usertype ==
                                            "1") {
                                          orignalPrice = double.parse(
                                              recomProductDataList[index]
                                                  .mrp
                                                  .toString());
                                          //          *
                                          // int.parse(
                                          //     recomProductDataList[index]
                                          //         .qty
                                          //         .toString());
                                          sellingPrice = double.parse(
                                              recomProductDataList[index]
                                                  .b2cselprice
                                                  .toString());
                                          //          *
                                          // int.parse(
                                          //     recomProductDataList[index]
                                          //         .qty
                                          //         .toString());
                                        } else if (userDataService
                                                .userData.usertype ==
                                            "2") {
                                          orignalPrice = double.parse(
                                              recomProductDataList[index]
                                                  .mrp
                                                  .toString());
                                          //          *
                                          // int.parse(
                                          //     recomProductDataList[index]
                                          //         .qty
                                          //         .toString());
                                          sellingPrice = double.parse(
                                              recomProductDataList[index]
                                                  .b2bselprice
                                                  .toString());
                                          //         *
                                          // int.parse(
                                          //     recomProductDataList[index]
                                          //         .qty
                                          //         .toString());
                                        }
                                        return GestureDetector(
                                          onTap: () {
                                            Get.to(ProductDescription(
                                                recomProductDataList[index]
                                                    .productid));
                                          },
                                          child: Container(
                                            alignment: Alignment.center,
                                            margin: EdgeInsets.only(
                                                bottom: 5.h, right: 10.w),
                                            //height: 280.h,
                                            width: 150.w,
                                            decoration: BoxDecoration(
                                                color: Colors.black12,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Column(
                                              children: [
                                                Container(
                                                  height: 100.h,
                                                  child: Stack(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  right: 0.w,
                                                                  top: 0.h),
                                                          child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        15.w),
                                                                bottomLeft: Radius
                                                                    .circular(
                                                                        12.w),
                                                                topRight: Radius
                                                                    .circular(
                                                                        15.w),
                                                                bottomRight: Radius
                                                                    .circular(
                                                                        12.w),
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left:
                                                                            3.w,
                                                                        right:
                                                                            3.w,
                                                                        top: 3
                                                                            .h),
                                                                child: Image
                                                                    .network(
                                                                  ApiConstants
                                                                          .IMAGE_URL +
                                                                      recomProductDataList[
                                                                              index]
                                                                          .imgurl,
                                                                  height: 100.h,
                                                                  width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width
                                                                      .w,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                ),
                                                              ))),
                                                      // Align(
                                                      //     alignment: Alignment
                                                      //         .topRight,
                                                      //     child: Padding(
                                                      //       padding:
                                                      //           EdgeInsets.only(
                                                      //               right: 2.w,
                                                      //               top: 2.h),
                                                      //       child: (recomProductDataList[index]
                                                      //                       .wishlist !=
                                                      //                   null &&
                                                      //               recomProductDataList[index]
                                                      //                       .wishlist !=
                                                      //                   "")
                                                      //           ? GestureDetector(
                                                      //               onTap: () {
                                                      //                 BlocProvider.of<ProductBloc>(context).add(DeleteFromWishDatalist(
                                                      //                     context:
                                                      //                         context,
                                                      //                     wishListId: recomProductDataList[index]
                                                      //                         .wishlist,
                                                      //                     productDataList:
                                                      //                         recomProductDataList,
                                                      //                     currentIndex:
                                                      //                         index));
                                                      //               },
                                                      //               child: Icon(
                                                      //                 Icons
                                                      //                     .favorite,
                                                      //                 color: Colors
                                                      //                     .redAccent,
                                                      //                 size:
                                                      //                     30.sp,
                                                      //               ),
                                                      //             )
                                                      //           : GestureDetector(
                                                      //               onTap: () {
                                                      //                 BlocProvider.of<ProductBloc>(context).add(AddtoWishlist(
                                                      //                     context:
                                                      //                         context,
                                                      //                     productId: recomProductDataList[index]
                                                      //                         .productid,
                                                      //                     userId: userDataService
                                                      //                         .userData
                                                      //                         .customerid,
                                                      //                     userType: userDataService
                                                      //                         .userData
                                                      //                         .usertype,
                                                      //                     productDataList:
                                                      //                         recomProductDataList,
                                                      //                     currentIndex:
                                                      //                         index));
                                                      //               },
                                                      //               child: Icon(
                                                      //                 Icons
                                                      //                     .favorite_outline_rounded,
                                                      //                 color: Colors
                                                      //                     .redAccent,
                                                      //                 size:
                                                      //                     30.sp,
                                                      //               ),
                                                      //             ),
                                                      //     )),
                                                    ],
                                                  ),
                                                ),
                                                Container(
                                                  height: 100.h,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            child: Text(
                                                              recomProductDataList[
                                                                      index]
                                                                  .name,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize:
                                                                      12.sp),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "₹" +
                                                                sellingPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    15.sp),
                                                          ),
                                                          SizedBox(
                                                            width: 5.h,
                                                          ),
                                                          Text(
                                                            "₹" +
                                                                orignalPrice
                                                                    .toString(),
                                                            style: TextStyle(
                                                                decoration:
                                                                    TextDecoration
                                                                        .lineThrough,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    13.sp),
                                                          ),
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 5.h,
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                              onTap: () {},
                                                              child: (recomProductDataList[index]
                                                                              .cartlist !=
                                                                          null &&
                                                                      recomProductDataList[index]
                                                                              .cartlist !=
                                                                          "")
                                                                  ? Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              if (int.parse(recomProductDataList[index].qty) > 0) {
                                                                                qty = int.parse(recomProductDataList[index].qty);
                                                                                qty = qty - 1;
                                                                                BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: recomProductDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                              } else {
                                                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item quantity can not lesser than 0.")));
                                                                                //_scaffoldKey.currentState.showSnackBar(new SnackBar(content: new Text("Item quantity can not lesser than 1.")));
                                                                              }
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                24.h,
                                                                            width:
                                                                                24.w,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.red,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "-",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.w,
                                                                        ),
                                                                        Container(
                                                                          height:
                                                                              24.h,
                                                                          width:
                                                                              24.w,
                                                                          decoration: BoxDecoration(
                                                                              color: Colors.white70,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                              border: Border.all(color: Colors.black26, width: 1)),
                                                                          child:
                                                                              Center(
                                                                            child:
                                                                                Text(
                                                                              recomProductDataList[index].qty.toString(),
                                                                              style: TextStyle(color: Colors.black, fontSize: 18.sp),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                          width:
                                                                              5.w,
                                                                        ),
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              qty = int.parse(recomProductDataList[index].qty);
                                                                              qty = qty + 1;
                                                                              BlocProvider.of<ProductBloc>(context).add(EditCart(context: context, cartId: recomProductDataList[index].cartlist, userId: userDataService.userData.customerid, qty: qty.toString()));
                                                                            });
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                24.h,
                                                                            width:
                                                                                24.w,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black54,
                                                                              borderRadius: BorderRadius.circular(5),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: Text(
                                                                                "+",
                                                                                style: TextStyle(color: Colors.white, fontSize: 20.sp),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  : GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        BlocProvider.of<ProductBloc>(context).add(AddToCartEvent(
                                                                            context:
                                                                                context,
                                                                            productId: recomProductDataList[index]
                                                                                .productid
                                                                                .toString(),
                                                                            userId: userDataService
                                                                                .userData.customerid,
                                                                            userType: userDataService
                                                                                .userData.usertype,
                                                                            productDataList:
                                                                                recomProductDataList,
                                                                            currentIndex:
                                                                                index));
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        height:
                                                                            30.h,
                                                                        width:
                                                                            80.w,
                                                                        decoration: BoxDecoration(
                                                                            color:
                                                                                Colors.red,
                                                                            borderRadius: BorderRadius.circular(10)),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              Text(
                                                                            "ADD",
                                                                            style:
                                                                                TextStyle(color: Colors.white),
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    )),
                                                        ],
                                                      ),

                                                      // Row(
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment
                                                      //           .center,
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .center,
                                                      //   children: [
                                                      //     Text(
                                                      //       "₹" +
                                                      //           orignalPrice
                                                      //               .toString(),
                                                      //       style: TextStyle(
                                                      //           decoration:
                                                      //               TextDecoration
                                                      //                   .lineThrough,
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //           fontSize:
                                                      //               12.sp),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5.h,
                                                      // ),
                                                      // Row(
                                                      //   crossAxisAlignment:
                                                      //       CrossAxisAlignment
                                                      //           .center,
                                                      //   mainAxisAlignment:
                                                      //       MainAxisAlignment
                                                      //           .center,
                                                      //   children: [
                                                      //     Text(
                                                      //       "₹" +
                                                      //           sellingPrice
                                                      //               .toString(),
                                                      //       style: TextStyle(
                                                      //           fontWeight:
                                                      //               FontWeight
                                                      //                   .bold,
                                                      //           fontSize:
                                                      //               14.sp),
                                                      //     ),
                                                      //   ],
                                                      // ),
                                                      // SizedBox(
                                                      //   height: 5.h,
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                )),
                            SizedBox(
                              height: 20.h,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: BottomNavigationWidget(0))),
    );
  }
}
