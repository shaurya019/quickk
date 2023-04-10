// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
    json['customerid'] == null ? "" : json['customerid'] as String,
    json['firstname'] == null ? "" : json['firstname'] as String,
    json['lastname'] == null ? "" : json['lastname'] as String,
    json['emailid'] == null ? "" : json['emailid'] as String,
    json['mobileno'] == null ? "" : json['mobileno'] as String,
    json['latitude'] == null ? "" : json['latitude'] as String,
    json['longitude'] == null ? "" : json['longitude'] as String,
    json['prefx'] == null ? "" : json['prefx'] as String,
    json['address'] == null ? "" : json['address'] as String,
    json['pincode'] == null ? "" : json['pincode'] as String,
    json['city'] == null ? "" : json['city'] as String,
    json['state'] == null ? "" : json['state'] as String,
    json['usertype'] == null ? "" : json['usertype'] as String,
    json['active'] == null ? "" : json['active'] as String,
    json['createdfrom'] == null ? "" : json['createdfrom'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['updatedon'] == null ? "" : json['updatedon'] as String,
    json['lastlogin'] == null ? "" : json['lastlogin'] as String,
    json['ipaddress'] == null ? "" :  json['ipaddress'] as String,
    json['imgurl'] == null ? "" :  json['imgurl'] as String,
    json['referralcode'] == null ? "" : json['referralcode'] as String,
    json['referralcodeid'] == null ? "" : json['referralcodeid'].toString(),
    json['isapproved'] == null ? "" : json['isapproved'].toString()
);

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
  'customerid': instance.customerid,
  'firstname': instance.firstname,
  'lastname': instance.lastname,
  'emailid': instance.emailid,
  'mobileno': instance.mobileno,
  'latitude': instance.latitude,
  'longitude' : instance.longitude,
  'prefx' : instance.prefx,
  'address': instance.address,
  'pincode' : instance.pincode,
  'city': instance.city,
  'state' : instance.state,
  'usertype' : instance.usertype,
  'createdfrom' : instance.createdfrom,
  'createdon' : instance.createdon,
  'updatedon' : instance.updatedon,
  'lastlogin' : instance.lastlogin,
  'ipaddress' : instance.ipaddress,
  'imgurl' : instance.imgurl,
  'referralcode' : instance.referralcode,
  'referralcodeid' : instance.referralcodeid,
  'isapproved' : instance.isapproved
};
