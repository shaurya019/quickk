import 'package:flutter/material.dart';

class ColorResources {

  static const white = Colors.white;
  static const black = Colors.black;
  static const dash = Color(0xFFDDDDDD);
  static const couponTextColor = Color(0xFF2699FB);
  static const google_bg = Color(0xFFDB4437);
  static const facebook_bg = Color(0xFF4267B2);
  static const light_purple = Color(0xFF01044B);
  static const gradient_light_purple = Color(0xFFED00ED);
  static const light_blue = Color(0xFF6AC6FC);
  static const grey_text = Color(0xFF525252);
  static const grey_text_bold = Color(0xFF7C8085);
  static const app_bar_text = Color(0xFF4C5643);
  static const bottom_icon_unselect = Color(0xFF434B56);
  static const heart_outlined = Color(0xFFFF5757);
  static const shadow = Color(0xFF242424);
  static const button_yellow = Color(0xFFFDFD3A);
  static const cart_fav_item = Color(0xFFFFC107);
  static const grey_bg = Color(0xFFF1F1F1);
  static const grey_bg_bottomsheet = Color(0xFF707070);
  static const title_color_bottomsheet = Color(0xFF484D54);
  static const title_username = Color(0xFF272727);
  static const title_address = Color(0xFF7A8FA6);
  static const post_count = Color(0xFF1B1B1B);
  static const chart_titles = Color(0xFF4D4F5C);
  static const profile_bg = Color(0xFFFAFAFA);

  static const text_green= Color(0xFF33D051);
  static const text_cart_grey= Color(0xFF929292);
  static const text_cart_green_price= Color(0xFF00C569);
  static const delete_cart_item_bg= Color(0xFFFF3D00);
  static const cart_border= Color(0xFF343434);
  static const inactive= Color(0xFF800000);
  static const newItem= Color(0xFFE80057);
  static const orderNoText= Color(0xFF989898);
  static const orderDescText= Color(0xFF929292);
  static const card_bg_coupons_1= Color(0xFFFECFAF);
  static const card_bg_coupons_2= Color(0xFF6AC6FC);
  static const bar_green= Color(0xFF00960A);

  static const Color colorGrey = Color(0xFFA0A4A8);
  static const Color colorBlack = Color(0xFF262626);
  static const Color colorPrimary = Color(0xff00A858);

  static const color = [
    Colors.red,
    Colors.green,
    Colors.greenAccent,
    Colors.amberAccent,
    Colors.blue,
    Colors.amber,
  ];

  static const MaterialColor kToDark = MaterialColor(
    0xffFFFFFF, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Colors.black,//10%
      100: Colors.black,//20%
      200: Colors.black,//30%
      300: Colors.black,//40%
      400: Colors.black,//50%
      500: Colors.black,//60%
      600: Colors.black,//70%
      700: Colors.black,//80%
      800: Colors.black,//90%
      900: Colors.black,//100%
    },
  );

  static const MaterialColor kToLight = MaterialColor(
    0xff262626, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    <int, Color>{
      50: Colors.blue,//10%
      100: Colors.blue,//20%
      200: Colors.blue,//30%
      300: Colors.blue,//40%
      400: Colors.blue,//50%
      500: Colors.blue,//60%
      600: Colors.black,//70%
      700: Colors.black,//80%
      800: Colors.black,//90%
      900: Colors.black,//100%
    },
  );

  static const Map<int, Color> colorMap = {
    50: Color(0x10192D6B),
    100: Color(0x20192D6B),
    200: Color(0x30192D6B),
    300: Color(0x40192D6B),
    400: Color(0x50192D6B),
    500: Color(0x60192D6B),
    600: Color(0x70192D6B),
    700: Color(0x80192D6B),
    800: Color(0x90192D6B),
    900: Color(0xff192D6B),
  };
}