class PlaceSearch {
  final String? description;
  final String? placeId;

  PlaceSearch({this.description, this.placeId});

  factory PlaceSearch.fromJson(Map<String, dynamic> json) {
    return PlaceSearch(
        description: json['description'], placeId: json['place_id']);
  }
}

class NewPlaceSearch {
  final String? areaname;

  NewPlaceSearch({this.areaname});

  factory NewPlaceSearch.fromJson(Map<String, dynamic> json) {
    return NewPlaceSearch(areaname: json['areaname'] + ", " + json['cityname']);
  }
}
