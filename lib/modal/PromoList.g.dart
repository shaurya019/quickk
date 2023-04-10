// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PromoList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
PromoList _$PromoListFromJson(Map<String, dynamic> json) => PromoList(
      id: json['id'] == null ? "" : json['id'] as String,
      name: json['name'] == null ? "" : json['name'] as String,
      code: json['code'] == null ? "" : json['code'] as String,
      value: json['value'] == null ? "" : json['value'] as String,
      type: json['type'] == null ? "" : json['type'] as String,
      enddate: json['enddate'] == null ? "" : json['enddate'] as String,
    );

Map<String, dynamic> _$PromoListToJson(PromoList instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'code': instance.code,
      'value': instance.value,
      'type': instance.type,
      'enddate': instance.enddate,
    };
