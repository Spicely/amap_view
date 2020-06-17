import '../location_poi/index.dart';
import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class LocationGeocode {
  final String towncode;

  final String township;

  final String adCode;

  final String cityCode;

  final String country;

  final String formatAddress;

  final String province;

  List<LocationPoi> pois = [];

  LocationGeocode({
    this.adCode,
    this.cityCode,
    this.country,
    this.formatAddress,
    this.province,
    this.towncode,
    this.township,
    this.pois,
  });

  factory LocationGeocode.fromJson(Map<dynamic, dynamic> json) => _$LocationGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$LocationGeocodeToJson(this);
}
