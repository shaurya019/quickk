// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
    json['orderid'] == null ? "" : json['orderid'] as String,
    json['billingamount'] == null ? "" : json['billingamount'] as String,
    json['Discount'] == null ? "" : json['Discount'] as String,
    json['shiping'] == null ? "" : json['shiping'] as String,
    json['Total'] == null ? "" : json['Total'] as String,
    json['Address1'] == null ? "" : json['Address1'] as String,
    json['Address2'] == null ? "" : json['Address2'] as String,
    json['Address3'] == null ? "" : json['Address3'] as String,
    json['pincode'] == null ? "" : json['pincode'] as String,
    json['Status'] == null ? "" : json['Status'] as String,
    json['OrderDate'] == null ? "" : json['OrderDate'] as String,
    json['DeliveryDate'] == null ? "" : json['DeliveryDate'] as String,
    json['orderdetails'] == null ? null : (json['orderdetails'] as List<dynamic>).map((e) => OrderedProduct.fromJson(e as Map<String, dynamic>)).toList(),
);

Map<String, dynamic> _$OrderDataToJson(OrderData instance) => <String, dynamic>{
  'orderid': instance.orderid,
  'billingamount': instance.billingamount,
  'Discount' : instance.Discount,
  'shiping' : instance.shiping,
  'Total' : instance.Total,
  'Address1' : instance.Address1,
  'Address2' : instance.Address2,
   'Address3' : instance.Address3,
  'pincode' : instance.pincode,
  'Status' : instance.Status,
  'OrderDate' : instance.OrderDate,
  'DeliveryDate' : instance.DeliveryDate,
  'orderdetails' : instance.orderdetails
};
