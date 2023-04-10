// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductData _$ProductDataFromJson(Map<String, dynamic> json) => ProductData(
    json['productid'] == null ? "" : json['productid'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['categoryid'] == null ? "" : json['categoryid'] as String,
    json['subcategoryid'] == null ? "" : json['subcategoryid'] as String,
    json['imgurl'] == null ? "" : json['imgurl'] as String,
    json['mrp'] == null ? "" : json['mrp'] as String,
    json['b2bprice'] == null ? "" : json['b2bprice'] as String,
    json['b2bselprice'] == null ? "" : json['b2bselprice'] as String,
    json['b2cprice'] == null ? "" : json['b2cprice'] as String,
    json['b2cselprice'] == null ? "" : json['b2cselprice'] as String,
    json['description'] == null ? "" : json['description'] as String,
    json['benifit'] == null ? "" : json['benifit'] as String,
    json['info'] == null ? "" : json['info'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['updatedon'] == null ? "" : json['updatedon'] as String,
    json['active'] == null ? "" : json['active'] as String,
    json['category'] == null ? "" : json['category'] as String,
    json['wishlist'] == null ? "" : json['wishlist'] as String,
    json['cartlist'] == null ? "" : json['cartlist'] as String,
    json['qty'] == null ? "1" : json['qty'] as String);

Map<String, dynamic> _$ProductDataToJson(ProductData instance) =>
    <String, dynamic>{
      'productid': instance.productid,
      'name': instance.name,
      'categoryid': instance.categoryid,
      'subcategoryid': instance.subcategoryid,
      'imgurl': instance.imgurl,
      'mrp': instance.mrp,
      'b2bprice': instance.b2bprice,
      'b2bselprice': instance.b2bselprice,
      'b2cprice': instance.b2cprice,
      'b2cselprice': instance.b2cselprice,
      'description': instance.description,
      'benifit': instance.benifit,
      'info': instance.info,
      'createdon': instance.createdon,
      'updatedon': instance.updatedon,
      'active': instance.active,
      'category': instance.category,
      'wishlist': instance.wishlist,
      'cartlist': instance.cartlist,
      'qty': instance.qty
    };
