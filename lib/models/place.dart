import 'package:oim/models/Geometry.dart';

class Place {
  final Geometry? geometry;
  final String? name;
  final String? vicinity;

  Place({this.geometry, this.name, this.vicinity});

  factory Place.fromJson(Map<String, dynamic> json) {
    print('-----------------------------------------');
    print(json['formatted_address'].toString().split(',').length);
    print('-----------------------------------------');
    return Place(
      geometry: Geometry.fromJson(json['geometry']),
      name: json['address_components'][0]["long_name"].toString() +
          json['formatted_address'],
      vicinity: json['vicinity'],
    );
  }
}
