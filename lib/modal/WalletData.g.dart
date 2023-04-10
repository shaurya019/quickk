// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WalletData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WalletData _$WalletDataFromJson(Map<String, dynamic> json) => WalletData(
  json['id'] == null ? "" : json['id'] as String,
  json['customerid'] == null ? "" : json['customerid'] as String,
  json['amount'] == null ? "" : json['amount'] as String,
  json['type'] == null ? "" : json['type'] as String,
  json['balance'] == null ? "" : json['balance'] as String,
  json['remark'] == null ? "" : json['remark'] as String,
  json['createdon'] == null ? "" : json['createdon'] as String,
);

Map<String, dynamic> _$WalletDataToJson(WalletData instance) => <String, dynamic>{
  'id': instance.id,
  'customerid': instance.customerid,
  'amount' : instance.amount,
  'type' : instance.type,
  'balance' : instance.balance,
  'remark' : instance.remark,
  'balance' : instance.balance,
  'createdon' : instance.createdon,
};
