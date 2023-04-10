import 'package:json_annotation/json_annotation.dart';
import 'package:quickk/modal/OrderedProduct.dart';

part 'WalletData.g.dart';

@JsonSerializable()
class WalletData {


  String id;
  String customerid;
  String amount;
  String type;
  String balance;
  String remark;
  String createdon;




  WalletData(
      this.id,
      this.customerid,
      this.amount,
      this.type,
      this.balance,
      this.remark,
      this.createdon,

      );

  factory WalletData.fromJson(Map<String,dynamic> json) => _$WalletDataFromJson(json);
  Map<String, dynamic> toJson() => _$WalletDataToJson(this);
}
