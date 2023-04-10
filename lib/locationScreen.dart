import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:quickk/bloc/AddressBloc/AddressBloc.dart';

import 'package:quickk/const/colors.dart';
import 'package:quickk/homeScreen.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:quickk/repository/AddressRepository.dart';
import 'package:quickk/services/ServicesLocator.dart';
import 'package:quickk/services/UserDataServcie.dart';

class LocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => AddressBloc(AddressRepository(Dio())),
        child: LocationScreenStateful(),
      ),
    );
  }
}

class LocationScreenStateful extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<LocationScreenStateful> {
  String googleApikey = "AIzaSyDRsFR3V0IQXAvEoRAYRT74xmJNd6Vz7jo";
  GoogleMapController mapController;
  CameraPosition cameraPosition;
  LatLng startLocation = LatLng(27.6602292, 85.308027);
  String location = "Location Name:";
  LatLng _center;
  geolocator.Position currentLocation;
  String address1 = "", address2 = "", address3 = "";
  LocationData _locationData;
  String lat = "", lng = "", pincode = "";
  UserDataService userDataService = getIt<UserDataService>();

  @override
  void initState() {
    super.initState();
    getUserLocation();
  }

  getUserLocation() async {
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

    //_locationData = await location.getLocation();
    /*var latitude = _locationData.latitude.toString();
    var longitude = _locationData.longitude.toString();*/
    geolocator.Position currentLocation = await locateUser();
    setState(() {});
    var latitude = currentLocation.latitude.toString();
    var longitude = currentLocation.longitude.toString();
    lat = currentLocation.latitude.toString();
    lng = currentLocation.longitude.toString();
    List<geocoding.Placemark> placemarks =
        await geocoding.placemarkFromCoordinates(
            double.parse(latitude.toString()),
            double.parse(longitude.toString()));
    //String address = placemarks[0].name + "," + placemarks[0].street +"," +placemarks[0].locality+","+placemarks[0].administrativeArea+","+placemarks[0].country+","+placemarks[0].postalCode;

    setState(() {
      address1 = placemarks[0].name;
      address2 = placemarks[0].street +
          "," +
          placemarks[0].locality +
          "," +
          placemarks[0].administrativeArea;
      address3 = placemarks[0].country;
      pincode = placemarks[0].postalCode;
    });
  }

  Future<geolocator.Position> locateUser() async {
    return geolocator.Geolocator.getCurrentPosition(
        desiredAccuracy: geolocator.LocationAccuracy.high);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        actions: <Widget>[
          /*Padding(
            padding: EdgeInsets.only(right: 15.w,top: 12.h),
            child: GestureDetector(
              onTap: (){
                WidgetsBinding.instance.addPostFrameCallback((_){
                  Navigator.push(context, MaterialPageRoute(builder: (Context) => HomeScreen()));
                });
              },
              child: Text("Skip", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),),
            ),
          )*/
        ],
      ),
      body: BlocListener<AddressBloc, AddressState>(
        listener: (context, state) {
          if (state is AddressCompleteState) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Get.to(HomeScreen());
              //Navigator.push(context, MaterialPageRoute(builder: (Context) => HomeScreen()));
            });
          }
        },
        child: Column(
          children: [
            /*GoogleMap( //Map widget from google_maps_flutter package
            zoomGesturesEnabled: true, //enable Zoom in, out on map
            initialCameraPosition: CameraPosition( //innital position in map
              target: startLocation, //initial position
              zoom: 14.0, //initial zoom level
            ),
            mapType: MapType.normal, //map type
            onMapCreated: (controller) { //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
            onCameraMove: (CameraPosition cameraPositiona) {
              cameraPosition = cameraPositiona; //when map is dragging
            },
            onCameraIdle: () async { //when map drag stops
              List<Placemark> placemarks = await placemarkFromCoordinates(cameraPosition.target.latitude, cameraPosition.target.longitude);
              setState(() { //get place name from lat and lang
                location = placemarks.first.administrativeArea.toString() + ", " +  placemarks.first.street.toString();
              });
            },
          ),
        */
            Image.asset(
              "assets/mapsampleImage.png",
              width: MediaQuery.of(context).size.width.w,
              height: MediaQuery.of(context).size.height.h / 2.5,
              fit: BoxFit.fill,
            ),
            /*InkWell(
              onTap: () async {
                var place = await PlacesAutocomplete.show(
                    context: context,
                    apiKey: googleApikey,
                    mode: Mode.overlay,
                    types: [],
                    strictbounds: false,
                    components: [Component(Component.country, 'np')],
                    //google_map_webservice package
                    onError: (err){
                      print(err);
                    }
                );

                if(place != null){
                  setState(() {
                    location = place.description.toString();
                  });
                  //form google_maps_webservice package
                  final plist = GoogleMapsPlaces(apiKey:googleApikey,
                    apiHeaders: await GoogleApiHeaders().getHeaders(),
                    //from google_api_headers package
                  );
                  String placeid = place.placeId ?? "0";
                  final detail = await plist.getDetailsByPlaceId(placeid);
                  final geometry = detail.result.geometry;
                  final lat = geometry.location.lat;
                  final lang = geometry.location.lng;
                  var newlatlang = LatLng(lat, lang);

                  //move map camera to selected place with animation
                  mapController?.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: newlatlang, zoom: 17)));
                }
              },
              child:Padding(
                padding: EdgeInsets.all(15),
                child: Card(
                  child: Container(
                      padding: EdgeInsets.all(0),
                      width: MediaQuery.of(context).size.width - 40,
                      child: ListTile(
                        leading: Image.asset("assets/icon/agreement.png", width: 25,),
                        title:Text(location, style: TextStyle(fontSize: 18),),
                        trailing: Icon(Icons.search),
                        dense: true,
                      )
                  ),
                ),
              )
          ),*/
            Container(
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
              padding:
                  EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Location",
                    style: TextStyle(
                      color: ColorConstants.primaryColor,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Text(
                    'Your Location',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                        fontWeight: FontWeight.normal),
                  ),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Container(
                      height: 45,
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              height: 20,
                              child: Icon(
                                Icons.location_on,
                                size: 40,
                                color: Colors.amberAccent,
                              )),
                          Container(
                            width: 240.w,
                            height: 60.h,
                            child: TextField(
                              decoration: InputDecoration(
                                hintText:
                                    address1 + "," + address2 + "," + address3,
                                hintMaxLines: 2,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                              ),
                              onChanged: (value) {
                                var number = value.toString();
                              },
                            ),
                          ),
                        ],
                      )),
                  Padding(padding: EdgeInsets.only(top: 20)),
                  Center(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: 320,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 10.w, right: 10.w),
                              padding: EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Center(
                                child: Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 15,
                                ),
                              ),
                            ),
                            Text(
                              'Hurray, We Deliver here',
                              style: TextStyle(
                                  color: Colors.black54, fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      onTap: () {
                        //   Navigator.push(context, MaterialPageRoute(builder: (Context)=>HomeScreen()));
                      },
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 10)),
                  Center(
                    child: InkWell(
                      child: Container(
                        margin: EdgeInsets.only(bottom: 20),
                        width: 320,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: ColorConstants.primaryColor,
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: Text(
                            'Confirm Location',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                      onTap: () {
                        print(userDataService.userData.customerid.toString());
                        BlocProvider.of<AddressBloc>(context).add(
                            SaveAddressEvent(
                                context: context,
                                address1: address1,
                                address2: address2,
                                address3: address3,
                                pincode: pincode,
                                latitude: lat,
                                longitude: lng,
                                userid: userDataService.userData.customerid
                                    .toString()));
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
