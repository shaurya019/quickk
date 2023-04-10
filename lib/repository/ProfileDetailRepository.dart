import 'dart:io';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:quickk/provider/OTPVerificationProvider.dart';
import 'package:quickk/provider/ProfileDetailProvider.dart';


class ProfileDetailRepository{

  final Dio client;

  ProfileDetailProvider provider ;

  ProfileDetailRepository(this.client){
    provider = new ProfileDetailProvider(client);
  }


  Future<Response> saveProfileData(BuildContext context,String firstName , String lastname , String emailid ,String mobileno , String prefx,String usertype) => provider.saveProfileData(context,firstName,lastname,emailid,mobileno,prefx,usertype);

  Future<Response> editProfileData(BuildContext context,String firstName , String lastname , String emailid ,String prefx,String userId,File imageFile) => provider.editProfileData(context,firstName,lastname,emailid,prefx,userId,imageFile);

  Future<Response> documentUpload(BuildContext context,File imageFile , File documentFile , String documentId1 ,String documentId2 , String userid) => provider.documentUpload(context,imageFile,documentFile,documentId1,documentId2,userid);

}