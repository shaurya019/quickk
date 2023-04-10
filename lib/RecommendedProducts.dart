import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:quickk/bloc/HomeScreenBloc/HomeScreenBloc.dart';
import 'package:quickk/const/colors.dart';
import 'package:quickk/modal/CartData.dart';
import 'package:quickk/modal/OfferData.dart';
import 'package:quickk/modal/ProductData.dart';
import 'package:quickk/productDescription.dart';
import 'package:quickk/repository/HomeScreenRepository.dart';
import 'package:quickk/repository/ProductRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

import 'bloc/ProductBloc/ProductBloc.dart';

class RecommendedProducts extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => HomeScreenBloc(HomeScreenRepository(Dio())),
        child: RecommendedProductsStateful(),
      ),
    );
  }
}

class RecommendedProductsStateful extends StatefulWidget {

  @override
  _RecommendedProductsState createState() => _RecommendedProductsState();
}

class _RecommendedProductsState extends State<RecommendedProductsStateful> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<ProductData> recomProductDataList = List.empty(growable: true);
  UserDataService userDataService = getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(context: context));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
              child: BlocListener<HomeScreenBloc, HomeScreenState>(
                listener: (context, state) {
                  if(state is HomeDataListCompleteState){
                    setState(() {
                      recomProductDataList = state.recomProductDataList;
                    });
                  }
                },
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    children: [
                      Container(
                        width: 500.w,
                        height: 1,
                        color: Colors.black26,
                      ),
                      Container(
                        height: 40.h,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: 10.w,
                            ),
                            InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                  size: 30,
                                )),
                            SizedBox(
                              width: 10.w,
                            ),
                            /*Container(
                              height: 40.h,
                              width: 300.w,
                              padding: EdgeInsets.only(left: 20.w, right: 20.w),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: Colors.black26, width: 2)),
                              child: Center(
                                child: TextField(
                                  decoration: InputDecoration(
                                    hintText: "Search.......",
                                    hintMaxLines: 2,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.transparent),
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if(value != null && value != ""){
                                      BlocProvider.of<ProductBloc>(context).add(SearchProduct(context: context, text: value,userId: userDataService.userData.customerid));
                                    }
                                    else{
                                      BlocProvider.of<HomeScreenBloc>(context).add(HomeDataList(context: context));
                                    }
                                  },
                                ),
                              ),
                            )*/
                          ],
                        ),
                      ),
                      Container(
                        width: 500.w,
                        height: 1,
                        color: Colors.black26,
                      ),
                      SizedBox(
                        height: 0.h,
                      ),
                      Expanded(
                        child: Container(
                            width: 300.w,
                            margin: EdgeInsets.only(top: 5.h),
                            child: GridView.builder(
                                gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2, childAspectRatio: 4 / 4
                                ),
                                shrinkWrap: true,
                                itemCount: recomProductDataList.length,
                                itemBuilder: (BuildContext ctx, index) {
                                  return Container(
                                      width: MediaQuery.of(context).size.width.w/3.2.w,
                                      height: 100.h,
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          border: Border.all(color: Colors.black12,),
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      margin: EdgeInsets.only(right: 10.w,top: 10.h),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8.0),
                                        child:Image.network(ApiConstants.BASE_URL+recomProductDataList[index].imgurl,fit:BoxFit.fill,height: MediaQuery.of(context).size.height.h,width: MediaQuery.of(context).size.width.w),
                                      ) );
                                }
                            )
                        ),
                      )
                    ],
                  ),
                ),
              )),
        ));
  }
}
