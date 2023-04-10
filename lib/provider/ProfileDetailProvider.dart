import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quickk/Utils/ApiConstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileDetailException implements Exception {
  ProfileDetailException(error) {
    print(error);
  }
}

class ProfileDetailProvider {
  ProfileDetailProvider(this.client);

  final Dio client;

  String apiUrl = "";

  Future<Response> saveProfileData(
      BuildContext context,
      String firstName,
      String lastname,
      String emailid,
      String mobileno,
      String prefix,
      String usertype) async {
    Map data = {
      "firstName": firstName,
      "lastName": lastname,
      "email": emailid,
      "mobileno": mobileno,
      "prefix": prefix,
      "usertype": usertype,
      "referralcode": "",
      "fcm_token": ""
    };
// {"firstName": "jfjfj", "lastName": "ifif", "email":" ydyd@gmail.com", "mobileno": "6565656465", "prefix": "Mr", "usertype": "1"}
    print("data====>>>" + data.toString());

    apiUrl = ApiConstants.BASE_URL + ApiConstants.saveprofile;

    try {
      Response response = await client.post(
        apiUrl,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> editProfileData(
      BuildContext context,
      String firstName,
      String lastname,
      String emailid,
      String prefx,
      String userId,
      File imageFile) async {
    String fileName = "";
    if (imageFile != null) {
      fileName = imageFile.path.split('/').last;
    }

    FormData data;

    data = FormData.fromMap({
      "userid": userId,
      "firstName": firstName,
      "lastName": lastname,
      "email": emailid,
      "prefx": prefx,
      "file": (imageFile != null)
          ? await MultipartFile.fromFile(imageFile.path, filename: fileName)
          : "",
    });

    apiUrl = ApiConstants.BASE_URL + ApiConstants.editprofile;

    try {
      Response response = await client.post(
        apiUrl,
        data: data,
        options: Options(
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
        ),
      );
      print("response====>>>" + response.toString());
      return response;
    } catch (error) {
      return null;
    }
  }

  Future<Response> documentUpload(
      BuildContext context,
      File imageFile,
      File documentFile,
      String documentId1,
      String documentId2,
      String userid) async {
    apiUrl = ApiConstants.BASE_URL + ApiConstants.savedocument;

    FormData formData = FormData.fromMap({
      "file1": await MultipartFile.fromFile(imageFile.path,
          filename: imageFile.path.split('/').last),
      "file2": await MultipartFile.fromFile(documentFile.path,
          filename: documentFile.path.split('/').last),
      "docsid1": documentId1,
      "docsid2": documentId2,
      "userid": userid
    });

    Response response = await client.post(apiUrl, data: formData);
    print("response==+document===>>" + response.toString());
    return response;
  }
}
