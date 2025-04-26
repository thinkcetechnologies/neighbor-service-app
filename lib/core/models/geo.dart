import 'package:cloud_firestore/cloud_firestore.dart';

class Geo {
  final GeoPoint geopoint;
  final String geohash;

  Geo({required this.geopoint, required this.geohash});

  factory Geo.fromJson(Map<String, dynamic> json) => Geo(
    geohash: json['geohash'] as String,
    geopoint: json['geopoint'] as GeoPoint,
  );

  Map<String, dynamic> toJson(){
    return {
      "geopoint": geopoint,
      "geohash": geohash,
    };
  }
}
