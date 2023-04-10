import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickk/Utils/DialogUtils/ProgressDialog.dart';
import 'package:quickk/const/colors.dart';
import 'package:stylish_dialog/stylish_dialog.dart';

class DialogUtil {
  static BuildContext dialogContext;

  static showProgressDialog(String message, BuildContext context) {
    return StylishDialog(
            context: context,
            backgroundColor: Colors.transparent,
            alertType: StylishDialogType.PROGRESS,
            progressColor: ColorConstants.primaryColor)
        .show();
  }

  static dismissProgressDialog(BuildContext context) {
    Navigator.pop(context);
  }

  static showInfoDialog(String title, String message, BuildContext context) {
    return StylishDialog(
            context: context,
            backgroundColor: Colors.white,
            alertType: StylishDialogType.INFO,
            progressColor: ColorConstants.primaryColor,
            titleText: title,
            contentText: message,
            confirmButton: ElevatedButton(
              child: Text('Dismiss'),
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                  primary: ColorConstants.primaryColor,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold)),
            ),
            dismissOnTouchOutside: false)
        .show();
  }
}
