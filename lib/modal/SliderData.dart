import 'package:json_annotation/json_annotation.dart';

part 'SliderData.g.dart';

@JsonSerializable()
class SliderData {


  String id;
  String title;
  String imgurl;
  String active;
  String createdon;


  SliderData(
      this.id,
      this.title,
      this.imgurl,
      this.active,
      this.createdon
      );

  factory SliderData.fromJson(Map<String,dynamic> json) => _$SliderDataFromJson(json);
  Map<String, dynamic> toJson() => _$SliderDataToJson(this);
}
