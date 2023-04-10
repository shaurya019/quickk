import 'package:json_annotation/json_annotation.dart';

part 'LocationData.g.dart';

@JsonSerializable()
class LocationData {


  String id;
  String customerid;
  String address1;
  String address2;
  String address3;
  String pincode;
  String state;
  String city;
  String latitude;
  String longitude;
  String createdon;
  String updatedon;
  String isdelete;
  String type;


  LocationData(
      this.id,
      this.customerid,
      this.address1,
      this.address2,
      this.address3,
      this.pincode,
      this.state,
      this.city,
      this.latitude,
      this.longitude,
      this.createdon,
      this.updatedon,
      this.isdelete,
      this.type
      );

  factory LocationData.fromJson(Map<String,dynamic> json) => _$LocationDataFromJson(json);
  Map<String, dynamic> toJson() => _$LocationDataToJson(this);
}
