import 'package:json_annotation/json_annotation.dart';

part 'OfferData.g.dart';

@JsonSerializable()
class OfferData {


  String id;
  String categoryid;
  String disc;
  String disctype;
  String imgurl;
  String createdon;
  String updatedon;
  String active;
  String category;


  OfferData(
      this.id,
      this.categoryid,
      this.disc,
      this.disctype,
      this.imgurl,
      this.createdon,
      this.updatedon,
      this.active,
      this.category
      );

  factory OfferData.fromJson(Map<String,dynamic> json) => _$OfferDataFromJson(json);
  Map<String, dynamic> toJson() => _$OfferDataToJson(this);
}
