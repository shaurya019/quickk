import 'package:json_annotation/json_annotation.dart';
import 'package:quickk/modal/OrderedProduct.dart';

part 'OrderData.g.dart';

@JsonSerializable()
class OrderData {


  String orderid;
  String billingamount;
  String Discount;
  String shiping;
  String Total;
  String Address1;
  String Address2;
  String Address3;
  String pincode;
  String Status;
  String OrderDate;
  String DeliveryDate;
  List<OrderedProduct> orderdetails;



  OrderData(
      this.orderid,
      this.billingamount,
      this.Discount,
      this.shiping,
      this.Total,
      this.Address1,
      this.Address2,
      this.Address3,
      this.pincode,
      this.Status,
      this.OrderDate,
      this.DeliveryDate,
      this.orderdetails
      );

  factory OrderData.fromJson(Map<String,dynamic> json) => _$OrderDataFromJson(json);
  Map<String, dynamic> toJson() => _$OrderDataToJson(this);
}
