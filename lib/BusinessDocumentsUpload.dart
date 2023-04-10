import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickk/bloc/ProfileDetailBloc/ProfileDetailBloc.dart';
import 'package:quickk/homeScreen.dart';
import 'package:quickk/locationScreen.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickk/repository/ProfileDetailRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

enum ImageSourceType { gallery, camera }

class BusinessDocumentsUpload extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ProfileDetailBloc(ProfileDetailRepository(Dio())),
        child: BusinessDocumentsUploadStateful(),
      ),
    );
  }
}

class BusinessDocumentsUploadStateful extends StatefulWidget {
  @override
  _BusinessDocumentsUploadStatefulState createState() =>
      _BusinessDocumentsUploadStatefulState();
}

class _BusinessDocumentsUploadStatefulState
    extends State<BusinessDocumentsUploadStateful> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  String prefix = "Mr";
  File file, documentfile;

  var _image;
  var imagePicker = new ImagePicker();
  var type;
  FilePickerResult filePickerResult;
  PickedFile pickedFile;
  Random random = new Random();
  UserDataService userDataService = getIt<UserDataService>();
  bool uploadDocument = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: BlocListener<ProfileDetailBloc, ProfileDetailState>(
            listener: (context, state) {
              if (state is DocumentCompleteState) {
                Get.to(HomeScreen());
              }
            },
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              child: ListView(
                //mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 10.w, right: 10.h, top: 15.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Get.back();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 18.sp,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            "Upload Business Documents",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                        ]),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Container(
                    width: 500.w,
                    height: 1,
                    color: Colors.black26,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Column(
                    children: [
                      (_image != null)
                          ? Image.file(
                              _image,
                              height: 100.h,
                              width: 150.w,
                            )
                          : Image.asset(
                              "assets/dummyimage.png",
                              height: 100.h,
                              width: 150.w,
                            ),
                      (uploadDocument == true && _image == null)
                          ? Text(
                              "Please Select Image",
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () async {
                          _getFromGallery();
                        },
                        child: Container(
                          height: 30.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "Select Image",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Column(
                    children: [
                      (filePickerResult != null)
                          ? Container(
                              height: 100.h,
                              width: 150.w,
                              child: Text(
                                  filePickerResult.files.first.name.toString()),
                            )
                          : Image.asset(
                              "assets/document.png",
                              height: 100.h,
                              width: 150.w,
                            ),
                      (uploadDocument == true && filePickerResult == null)
                          ? Text(
                              "Please Select Document",
                              style: TextStyle(color: Colors.red),
                            )
                          : SizedBox(),
                      SizedBox(
                        height: 20.h,
                      ),
                      InkWell(
                        onTap: () async {
                          _getDocument();
                        },
                        child: Container(
                          height: 30.h,
                          width: 150.w,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                              child: Text(
                            "Select Document",
                            style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            uploadDocument = true;
                          });
                          if (_image != null && filePickerResult != null) {
                            BlocProvider.of<ProfileDetailBloc>(context).add(
                                DocumentUploadEvent(
                                    imageFile: _image,
                                    documentFile: documentfile,
                                    documentId1: pickedFile.path.toString() +
                                        random.nextInt(10000).toString(),
                                    documentId2: filePickerResult
                                            .files.single.path
                                            .toString() +
                                        random.nextInt(10000).toString(),
                                    userId: userDataService.userData.customerid
                                        .toString(),
                                    context: context));
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: 200.w,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Center(
                              child: Text(
                            "Upload Document",
                            style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )));
  }

  _getFromGallery() async {
    pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  _getDocument() async {
    filePickerResult = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (filePickerResult != null) {
      setState(() {
        documentfile = File(filePickerResult.files.single.path);
      });
    }
  }
}
