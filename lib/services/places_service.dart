import 'package:http/http.dart' as http;
import 'package:oim/constants/constant.dart';
import 'package:oim/constants/urls.dart';
import 'package:oim/models/ProductModel.dart';
import 'package:oim/models/place.dart';

import 'dart:convert' as convert;

import 'package:oim/models/place_search.dart';

class PlacesService {
  final key = mapApiKey;

  Future<List<NewPlaceSearch>> getAutocomplete(String search) async {
    var url = Uri.parse(getareasearch + '$search');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json["data"]['areas'] as List;
    print(jsonResults);
    return jsonResults.map((place) => NewPlaceSearch.fromJson(place)).toList();
  }

  Future<List<NewProductSearch>> getAutocompleteProduct(String search) async {
    var url = Uri.parse(getproductsearch + '$search');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json["data"]['products'] as List;
    return jsonResults
        .map((place) => NewProductSearch.fromJson(place))
        .toList();
  }

  Future<List<NewSellerSearch>> getAutocompleteSeller(String search) async {
    var url = Uri.parse(getsellersearch + '$search');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    print(json);
    var jsonResults = json["data"]['sellers'] as List;
    return jsonResults.map((place) => NewSellerSearch.fromJson(place)).toList();
  }

  Future<List<NewProductSearch>> getAutocompleteSellerProduct(
      String search, String sellerid) async {
    var url = Uri.parse(getproductsearchseller + '$search' + '/$sellerid');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json["data"]['products'] as List;
    return jsonResults
        .map((place) => NewProductSearch.fromJson(place))
        .toList();
  }

  Future<Place> getPlace(String placeId) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResult = json['result'] as Map<String, dynamic>;
    return Place.fromJson(jsonResult);
  }

  Future<List<Place>> getPlaces(
      double lat, double lng, String placeType) async {
    var url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/textsearch/json?location=$lat,$lng&type=$placeType&rankby=distance&key=$key');
    var response = await http.get(url);
    var json = convert.jsonDecode(response.body);
    var jsonResults = json['results'] as List;
    print(jsonResults);
    return jsonResults.map((place) => Place.fromJson(place)).toList();
  }
}
