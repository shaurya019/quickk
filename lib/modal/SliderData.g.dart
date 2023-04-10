// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SliderData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SliderData _$SliderDataFromJson(Map<String, dynamic> json) => SliderData(
  json['id'] == null ? "" : json['id'] as String,
  json['title'] == null ? "" : json['title'] as String,
  json['imgurl'] == null ? "" : json['imgurl'] as String,
  json['active'] == null ? "" : json['active'] as String,
  json['createdon'] == null ? "" : json['createdon'] as String
);

Map<String, dynamic> _$SliderDataToJson(SliderData instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'imgurl' : instance.imgurl,
  'active' : instance.active,
  'createdon' : instance.createdon
};
