import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';

class LocationUtil{

  static getUserLocation() async {
    /*currentLocation = await locateUser();
    setState(() {
      _center = LatLng(currentLocation.latitude, currentLocation.longitude);
    });
    print('center $_center');*/

    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    var latitude = _locationData.latitude.toString();
    var longitude = _locationData.longitude.toString();
    List<geocoding.Placemark> placemarks = await geocoding.placemarkFromCoordinates(double.parse(latitude.toString()), double.parse(longitude.toString()));
    String address = placemarks[0].name + "," + placemarks[0].street +"," +placemarks[0].locality+","+placemarks[0].administrativeArea+","+placemarks[0].country+","+placemarks[0].postalCode;
    print("placemarks====>>>"+placemarks.toString());
    print("address====>>>"+address);
    return address;
  }

  Future<geolocator.Position> locateUser() async {
    return Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high);
  }



}