// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CategoryData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryData _$CategoryDataFromJson(Map<String, dynamic> json) => CategoryData(
    json['id'] == null ? "" : json['id'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['imgurl'] == null ? "" : json['imgurl'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['updatedon'] == null ? "" : json['updatedon'] as String,
    json['active'] == null ? "" : json['active'] as String
);

Map<String, dynamic> _$CategoryDataToJson(CategoryData instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'imgurl' : instance.imgurl,
  'createdon' : instance.createdon,
  'updatedon' : instance.updatedon,
  'active' : instance.active
};
