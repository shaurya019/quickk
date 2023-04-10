import 'package:json_annotation/json_annotation.dart';

part 'WishListData.g.dart';

@JsonSerializable()
class WishListData {


  String id;
  String productid;
  String categoryid;
  String b2cprice;
  String b2cselprice;
  String b2bprice;
  String b2bselprice;
  String qty;
  String customerid;
  String usertype;
  String createdon;
  String createdfrom;
  String isdelete;
  String deletedon;
  String updatedon;
  String name;
  String imgurl;


  WishListData(
      this.id,
      this.productid,
      this.categoryid,
      this.b2cprice,
      this.b2cselprice,
      this.b2bprice,
      this.b2bselprice,
      this.qty,
      this.customerid,
      this.usertype,
      this.createdon,
      this.createdfrom,
      this.isdelete,
      this.deletedon,
      this.updatedon,
      this.name,
      this.imgurl
      );

  factory WishListData.fromJson(Map<String,dynamic> json) => _$WishListDataFromJson(json);
  Map<String, dynamic> toJson() => _$WishListDataToJson(this);
}
