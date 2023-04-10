// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OfferData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OfferData _$OfferDataFromJson(Map<String, dynamic> json) => OfferData(
    json['id'] == null ? "" : json['id'] as String,
    json['categoryid'] == null ? "" : json['categoryid'] as String,
    json['disc'] == null ? "" : json['disc'] as String,
    json['disctype'] == null ? "" : json['disctype'] as String,
    json['imgurl'] == null ? "" : json['imgurl'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['updatedon'] == null ? "" : json['updatedon'] as String,
    json['active'] == null ? "" : json['active'] as String,
    json['category'] == null ? "" : json['category'] as String
);

Map<String, dynamic> _$OfferDataToJson(OfferData instance) => <String, dynamic>{
  'id': instance.id,
  'categoryid': instance.categoryid,
  'disc' : instance.disc,
  'disctype' : instance.disctype,
  'imgurl' : instance.imgurl,
  'createdon' : instance.createdon,
  'updatedon' : instance.updatedon,
  'active' : instance.active,
  'category' : instance.category
};
