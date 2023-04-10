// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationData _$LocationDataFromJson(Map<String, dynamic> json) => LocationData(
  json['id'] == null ? "" : json['id'] as String,
  json['customerid'] == null ? "" : json['customerid'] as String,
  json['address1'] == null ? "" : json['address1'] as String,
  json['address2'] == null ? "" : json['address2'] as String,
  json['address3'] == null ? "" : json['address3'] as String,
  json['pincode'] == null ? "" : json['pincode'] as String,
  json['state'] == null ? "" : json['state'] as String,
  json['city'] == null ? "" : json['city'] as String,
    json['latitude'] == null ? "" : json['latitude'] as String,
    json['longitude'] == null ? "" : json['longitude'] as String,
  json['createdon'] == null ? "" : json['createdon'] as String,
  json['updatedon'] == null ? "" : json['updatedon'] as String,
  json['isdelete'] == null ? "" : json['isdelete'] as String,
  json['type'] == null ? "" : json['type'] as String
);

Map<String, dynamic> _$LocationDataToJson(LocationData instance) => <String, dynamic>{
  'id': instance.id,
  'customerid': instance.customerid,
  'address1' : instance.address1,
  'address2' : instance.address2,
  'address3' : instance.address3,
  'pincode' : instance.pincode,
  'state' : instance.state,
  'city' : instance.city,
  'latitude' : instance.latitude,
  'longitude' : instance.longitude,
  'createdon' : instance.createdon,
  'updatedon' : instance.updatedon,
  'isdelete' : instance.isdelete,
  'type' : instance.type
 };
