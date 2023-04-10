// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'WishListData.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishListData _$WishListDataFromJson(Map<String, dynamic> json) => WishListData(
    json['id'] == null ? "" : json['id'] as String,
    json['productid'] == null ? "" : json['productid'] as String,
    json['categoryid'] == null ? "" : json['categoryid'] as String,
    json['b2cprice'] == null ? "" : json['b2cprice'] as String,
    json['b2cselprice'] == null ? "" : json['b2cselprice'] as String,
    json['b2bprice'] == null ? "" : json['b2bprice'] as String,
    json['b2bselprice'] == null ? "" : json['b2bselprice'] as String,
    json['qty'] == null ? "" : json['qty'] as String,
    json['customerid'] == null ? "" : json['customerid'] as String,
    json['usertype'] == null ? "" : json['usertype'] as String,
    json['createdon'] == null ? "" : json['createdon'] as String,
    json['createdfrom'] == null ? "" : json['createdfrom'] as String,
    json['isdelete'] == null ? "" : json['isdelete'] as String,
    json['deletedon'] == null ? "" : json['deletedon'] as String,
    json['updatedon'] == null ? "" : json['updatedon'] as String,
    json['name'] == null ? "" : json['name'] as String,
    json['imgurl'] == null ? "" : json['imgurl'] as String
);

Map<String, dynamic> _$WishListDataToJson(WishListData instance) => <String, dynamic>{
  'id': instance.id,
  'productid': instance.productid,
  'categoryid' : instance.categoryid,
  'b2cprice' : instance.b2cprice,
  'b2cselprice' : instance.b2cselprice,
  'b2bprice' : instance.b2bprice,
  'b2bselprice' : instance.b2bselprice,
  'qty' : instance.qty,
  'customerid' : instance.customerid,
  'usertype' : instance.usertype,
  'createdon' : instance.createdon,
  'createdfrom' : instance.createdfrom,
  'isdeleted' : instance.isdelete,
  'deletedon' : instance.deletedon,
  'updatedon' : instance.updatedon,
  'name' : instance.name,
  'imgurl' : instance.imgurl
};
