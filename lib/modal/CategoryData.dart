import 'package:json_annotation/json_annotation.dart';

part 'CategoryData.g.dart';

@JsonSerializable()
class CategoryData {


  String id;
  String name;
  String imgurl;
  String createdon;
  String updatedon;
  String active;


  CategoryData(
      this.id,
      this.name,
      this.imgurl,
      this.createdon,
      this.updatedon,
      this.active
      );

  factory CategoryData.fromJson(Map<String,dynamic> json) => _$CategoryDataFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDataToJson(this);
}
