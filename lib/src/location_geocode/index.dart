part of amap_location;

class LocationGeocode {
  final String towncode;

  final String township;

  final String adCode;

  final String cityCode;

  final String country;

  final String formatAddress;

  final String province;

  List<LocationPois> pois = [];

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

LocationGeocode _$LocationGeocodeFromJson(Map<dynamic, dynamic> json) {
  return LocationGeocode(
      adCode: json['adCode'] as String,
      cityCode: json['cityCode'] as String,
      country: json['country'] as String,
      formatAddress: json['formatAddress'] as String,
      province: json['province'] as String,
      towncode: json['towncode'] as String,
      township: json['township'] as String,
      pois: (json['pois'] as List)?.map((e) => e == null ? null : LocationPois.fromJson(new Map<String, dynamic>.from(e)))?.toList());
}

Map<String, dynamic> _$LocationGeocodeToJson(LocationGeocode instance) => <String, dynamic>{
      'towncode': instance.towncode,
      'township': instance.township,
      'adCode': instance.adCode,
      'cityCode': instance.cityCode,
      'country': instance.country,
      'formatAddress': instance.formatAddress,
      'province': instance.province,
      'pois': instance.pois
    };
