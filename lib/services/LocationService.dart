import 'package:quickk/modal/LocationData.dart';

class LocationDataService{

  LocationData locationData;


  setLocationData(LocationData _locationData) {
    locationData = _locationData;
  }

  LocationData get userData => locationData;
}