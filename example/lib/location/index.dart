import '../location_geocode/index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class Location {
  final double latitude;

  final double longitude;

  final String address;

  final String country;

  final String city;

  final String street;

  final String district;

  final double accuracy;

  final LocationGeocode geocode;

  Location({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.address,
    this.city,
    this.country,
    this.district,
    this.street,
    this.geocode,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}