import 'package:json_annotation/json_annotation.dart';

part 'UserData.g.dart';

@JsonSerializable()
class UserData {


  String customerid;
  String firstname;
  String lastname;
  String emailid;
  String mobileno;
  String latitude;
  String longitude;
  String prefx;
  String address;
  String pincode;
  String city;
  String state;
  String usertype;
  String active;
  String createdfrom;
  String createdon;
  String updatedon;
  String lastlogin;
  String ipaddress;
  String imgurl;
  String referralcode;
  String referralcodeid;
  String isapproved;

  UserData(
      this.customerid,
      this.firstname,
      this.lastname,
      this.emailid,
      this.mobileno,
      this.latitude,
      this.longitude,
      this.prefx,
      this.address,
      this.pincode,
      this.city,
      this.state,
      this.usertype,
      this.active,
      this.createdfrom,
      this.createdon,
      this.updatedon,
      this.lastlogin,
      this.ipaddress,
      this.imgurl,
      this.referralcode,
      this.referralcodeid,
      this.isapproved
      );

  factory UserData.fromJson(Map<String,dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}
