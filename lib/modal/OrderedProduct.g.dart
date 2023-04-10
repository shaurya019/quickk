// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderedProduct.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderedProduct _$OrderedProductFromJson(Map<String, dynamic> json) => OrderedProduct(
    json['id'] == null ? "" : json['id'] as String,
    json['orderid'] == null ? "" : json['orderid'] as String,
    json['productid'] == null ? "" : json['productid'] as String,
    json['qty'] == null ? "" : json['qty'] as String,
    json['price'] == null ? "" : json['price'] as String,
    json['totalamount'] == null ? "" : json['totalamount'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['customerid'] == null ? "" : json['customerid'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['imgurl'] == null ? "" : json['imgurl'] as String,
);

Map<String, dynamic> _$OrderedProductToJson(OrderedProduct instance) => <String, dynamic>{
  'id': instance.id,
  'orderid': instance.orderid,
  'productid' : instance.productid,
  'qty' : instance.qty,
  'price' : instance.price,
  'totalamount' : instance.totalamount,
  'createdon' : instance.createdon,
  'customerid' : instance.customerid,
  'name' : instance.name,
  'imgurl' : instance.imgurl,
};
