import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quickk/provider/profile.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Term extends StatefulWidget {
  const Term({Key key}) : super(key: key);

  @override
  _AboutUsState createState() => _AboutUsState();
}

class _AboutUsState extends State<Term> {
  List term = [];
  bool loading = false;
  @override
  void initState() {
    super.initState();
    tc();
  }

  tc() async {
    setState(() {
      loading = true;
    });
    try {
      var res = await Provider().tc();
      setState(() {
        term.addAll(res['data']);
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
          "Terms & Conditions",
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
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Card(
                      elevation: 10,
                      child: Container(
                          width: 250.w,
                          margin: EdgeInsets.all(20.w),
                          child: Html(
                            customTextStyle: (node, TextStyle baseStyle) {
                              return baseStyle.merge(TextStyle(fontSize: 12));
                            },
                            data: term[0]['text'].toString(),

                            // defaultTextStyle: TextStyle(
                            //     fontSize: 15,
                            //     color: Colors.blue,
                            //     fontWeight: FontWeight.bold),

                            // linkStyle: TextStyle(fontSize: 18),
                          )),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
