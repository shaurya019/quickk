import 'package:json_annotation/json_annotation.dart';

part 'CartData.g.dart';

@JsonSerializable()
class CartData {


  String id;
  String productid;
  String categoryid;
  String customerid;
  String usertype;
  String b2cprice;
  String b2cselprice;
  String b2bprice;
  String b2bselprice;
  String qty;
  String createdon;
  String createdfrom;
  String isdeleted;
  String deletedon;
  String updatedon;
  String name;
  String imgurl;


  CartData(
      this.id,
      this.productid,
      this.categoryid,
      this.customerid,
      this.usertype,
      this.b2cprice,
      this.b2cselprice,
      this.b2bprice,
      this.b2bselprice,
      this.qty,
      this.createdon,
      this.createdfrom,
      this.isdeleted,
      this.deletedon,
      this.updatedon,
      this.name,
      this.imgurl
      );

  factory CartData.fromJson(Map<String,dynamic> json) => _$CartDataFromJson(json);
  Map<String, dynamic> toJson() => _$CartDataToJson(this);
}
