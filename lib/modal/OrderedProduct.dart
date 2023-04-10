import 'package:json_annotation/json_annotation.dart';

part 'OrderedProduct.g.dart';

@JsonSerializable()
class OrderedProduct {


  String id;
  String orderid;
  String productid;
  String qty;
  String price;
  String totalamount;
  String createdon;
  String customerid;
  String name;
  String imgurl;



  OrderedProduct(
      this.id,
      this.orderid,
      this.productid,
      this.qty,
      this.price,
      this.totalamount,
      this.createdon,
      this.customerid,
      this.name,
      this.imgurl,
      );

  factory OrderedProduct.fromJson(Map<String,dynamic> json) => _$OrderedProductFromJson(json);
  Map<String, dynamic> toJson() => _$OrderedProductToJson(this);
}
