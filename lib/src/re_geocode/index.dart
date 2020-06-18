part of amap_core;

class ReGeocode {
  final String towncode;

  final String township;

  final String adCode;

  final String cityCode;

  final String country;

  final String formatAddress;

  final String province;

  List<ReGeocode> pois = [];

  ReGeocode({
    this.adCode,
    this.cityCode,
    this.country,
    this.formatAddress,
    this.province,
    this.towncode,
    this.township,
    this.pois,
  });

  factory ReGeocode.fromJson(Map<dynamic, dynamic> json) => _$ReGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$ReGeocodeToJson(this);
}

ReGeocode _$ReGeocodeFromJson(Map<dynamic, dynamic> json) {
  return ReGeocode(
      adCode: json['adCode'] as String,
      cityCode: json['cityCode'] as String,
      country: json['country'] as String,
      formatAddress: json['formatAddress'] as String,
      province: json['province'] as String,
      towncode: json['towncode'] as String,
      township: json['township'] as String,
      pois: (json['pois'] as List)?.map((e) => e == null ? null : ReGeocode.fromJson(new Map<String, dynamic>.from(e)))?.toList());
}

Map<String, dynamic> _$ReGeocodeToJson(ReGeocode instance) => <String, dynamic>{
      'towncode': instance.towncode,
      'township': instance.township,
      'adCode': instance.adCode,
      'cityCode': instance.cityCode,
      'country': instance.country,
      'formatAddress': instance.formatAddress,
      'province': instance.province,
      'pois': instance.pois
    };
