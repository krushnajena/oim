import 'package:geocoding/geocoding.dart';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:oim/constants/constant.dart';
import 'package:oim/models/place.dart';
import 'package:oim/models/place_search.dart';
import 'package:oim/services/places_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class LocationProvider with ChangeNotifier {
  double? latitude = 0;
  double? logitude = 0;
  bool permissionAllowed = false;
  Placemark? selectedAddress;
  List<NewPlaceSearch>? searchResults;

  Future<void> getCurrentPosition() async {
    LocationPermission permission;
    bool serviceEnabled;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print("Permission Denied");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print("Permission Denied 1");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print("Permission Denied");
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    if (position != null) {
      this.latitude = position.latitude;
      this.logitude = position.longitude;
      this.permissionAllowed = true;
      notifyListeners();
    } else {
      print("Permission Denied");
    }
  }

  void setLocation(double lat, double lang) {
    this.latitude = lat;
    this.logitude = lang;
    notifyListeners();
  }

  void onCameraMove(CameraPosition position) async {
    this.latitude = position.target.latitude;
    this.logitude = position.target.longitude;
    notifyListeners();
  }

  Future<void> getMoveCamera() async {
    List<Placemark> address = await placemarkFromCoordinates(
        this.latitude as double, this.logitude as double);
    print('*************************');
    print(address.first);
    print('*************************');
    this.selectedAddress = address.first;
    print(address.first);
    notifyListeners();
  }

  searchPlaces(String searchTerm) async {
    final placesService = PlacesService();
    searchResults = await placesService.getAutocomplete(searchTerm);
    notifyListeners();
  }

  Future<void> setSelectedLocation(String placeId) async {
    final placesService = PlacesService();
    final key = mapApiKey;
    // var sLocation = await placesService.getPlace(placeId);
    print(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key');
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    print(json['result']);
    var sLocation = Place.fromJson(jsonResult);

    this.latitude = sLocation.geometry!.location!.lat;
    this.logitude = sLocation.geometry!.location!.lng;
    print(sLocation.geometry!.location!.lat);
    searchResults = null;
    notifyListeners();
  }
}
