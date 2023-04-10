import 'package:json_annotation/json_annotation.dart';
part 'PromoList.g.dart';

@JsonSerializable()
class PromoList {
  String id;
  String name;
  String code;
  String value;
  String type;
  String enddate;

  PromoList(
      {this.id, this.name, this.value, this.type, this.enddate, this.code});
  factory PromoList.fromJson(Map<String, dynamic> json) =>
      _$PromoListFromJson(json);
  Map<String, dynamic> toJson() => _$PromoListToJson(this);
}
