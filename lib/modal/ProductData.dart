import 'package:json_annotation/json_annotation.dart';

part 'ProductData.g.dart';

@JsonSerializable()
class ProductData {
  String productid;
  String name;
  String categoryid;
  String subcategoryid;
  String imgurl;
  String mrp;
  String b2bprice;
  String b2bselprice;
  String b2cprice;
  String b2cselprice;
  String description;
  String benifit;
  String info;
  String createdon;
  String updatedon;
  String active;
  String category;
  String wishlist;
  String cartlist;
  String qty;

  ProductData(
      this.productid,
      this.name,
      this.categoryid,
      this.subcategoryid,
      this.imgurl,
      this.mrp,
      this.b2bprice,
      this.b2bselprice,
      this.b2cprice,
      this.b2cselprice,
      this.description,
      this.benifit,
      this.info,
      this.createdon,
      this.updatedon,
      this.active,
      this.category,
      this.wishlist,
      this.cartlist,
      this.qty);

  factory ProductData.fromJson(Map<String, dynamic> json) =>
      _$ProductDataFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDataToJson(this);
}
