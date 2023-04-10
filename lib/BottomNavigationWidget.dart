import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:quickk/ProfileScreen.dart';
import 'package:quickk/enterMobile.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/orderScreen.dart';
import 'package:quickk/searchScreen.dart';


class BottomNavigationWidget extends StatefulWidget {
  int bottomIndex;

  BottomNavigationWidget(int _bottomIndex){
    bottomIndex = _bottomIndex;
  }

  @override
  _BottomNavigationWidgetState createState() => _BottomNavigationWidgetState();
}



class _BottomNavigationWidgetState extends State<BottomNavigationWidget> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.bottomIndex,
      mouseCursor: SystemMouseCursors.grab,
      selectedItemColor: Colors.amberAccent,
      showUnselectedLabels: true,
      unselectedIconTheme: IconThemeData(
        color: Colors.black,
      ),
      unselectedItemColor: Colors.black,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon( AssetImage("assets/search.png",  ),size: 20, ),
          label: 'Search',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon( AssetImage("assets/order-now.png",  ), size: 25, ),
          label: 'Order',
        ),
        BottomNavigationBarItem(
          icon: ImageIcon( AssetImage("assets/user.png",  ), size: 25, ),
          label: 'Profile',
        ),
      ],
      onTap: (index) async {
        if(index==3){
          await Future.delayed(Duration(seconds: 0));
          //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => ProfileScreen(), transitionDuration: Duration.zero,),);
          Get.to(ProfileScreen());
        }
        if(index==2){
          await Future.delayed(Duration(seconds: 0));
          //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => OrderScreen(), transitionDuration: Duration.zero,),);
          Get.to(OrderScreen());
        }
        if(index==1){
          await Future.delayed(Duration(seconds: 0));
          //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => SearchScreen(), transitionDuration: Duration.zero,),);
          Get.to(SearchScreen());
        }
        if(index==0){
          await Future.delayed(Duration(seconds: 0));
          //Navigator.push(context, PageRouteBuilder(pageBuilder: (context, animation1, animation2) => HomeScreen(), transitionDuration: Duration.zero,),);
          Get.to(HomeScreen());
        }


      },
    );
  }






}
