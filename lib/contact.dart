import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickk/provider/profile.dart';

class Contact extends StatefulWidget {
  const Contact({Key key}) : super(key: key);

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<Contact> {
  List contactus = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    contact();
  }

  contact() async {
    setState(() {
      loading = true;
    });
    try {
      var res = await Provider().contact();
      setState(() {
        contactus.addAll(res['data']);
      });
      // toast(res['message'].toString());
      print(res['data']);
    } catch (e) {
      print(e.toString() + 'mmm');
      Fluttertoast.showToast(
          msg: e.toString(), toastLength: Toast.LENGTH_SHORT);
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Contact US",
            style: TextStyle(color: Colors.black, fontSize: 20),
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
        ),
        body: SingleChildScrollView(
          child: Center(
            child:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
                Card(
                  elevation: 10,
                  margin: EdgeInsets.only(top:20),
                  child: Container(
                    height: 520,
                    width: 300,
                    margin: EdgeInsets.all(20),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.mail),
                            Text(
                              ' Email ID:  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {},
                                child: Text('support@quickk.co.in'),
                                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:35),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.mail),
                            Text(
                              ' Email ID:  ',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold
                                  ),
                            ),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:  () {},
                                child: Text('sale@quickk.co.in'),
                                style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height:50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.phone),
                            Text(
                              'PhoneNo 1:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                  ),
                            ),
                            ElevatedButton(
                              onPressed:  () {},
                              child: Text('+91-9810119906'),
                              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            ),
                          ],
                        ),
                        SizedBox(height:30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.phone),
                            Text(
                              'PhoneNo 2:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                  ),
                            ),
                            ElevatedButton(
                              onPressed:  () {},
                              child: Text('+91-9810119905'),
                              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            ),
                          ],
                        ),
                        SizedBox(height:30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.dialer_sip),
                            Text(
                              'OfficeNo 1:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500
                                 ),
                            ),
                            ElevatedButton(
                              onPressed:  () {},
                              child: Text('0129-12345678'),
                              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            ),
                          ],
                        ),
                        SizedBox(height:30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.dialer_sip),
                            Text(
                              'OfficeNo 2:',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                fontWeight: FontWeight.w500
                                  ),
                            ),
                            ElevatedButton(
                              onPressed: () {},
                              child: Text('0129-12345678'),
                              style: ElevatedButton.styleFrom(primary: Colors.redAccent),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // ],
                  ),
                ),
                SizedBox(height: 20,),
                Image.asset(
                  "assets/QuickkLogo.png",
                  height: 130,
                ),
              ],
            ),
          ),
        )
    );
  }
}





//flutter_phone_direct_caller: ^2.1.1
//   url_launcher: ^6.1.10
//   permission_handler: ^9.2.0




//_callNumber() async{
// const number = '8383867619'; //set the number here
// bool? res = await FlutterPhoneDirectCaller.callNumber(number);
// }
//
//
// _sendEmail() {
//   final Uri _emailLaunchUri = Uri(
//     scheme: 'mailto',
//     path: 'xxxx@example.com',
//   );
//   launch(_emailLaunchUri.toString());
// }