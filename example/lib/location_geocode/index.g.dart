// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationGeocode _$LocationGeocodeFromJson(Map<String, dynamic> json) {
  return LocationGeocode(
      adCode: json['adCode'] as String,
      cityCode: json['cityCode'] as String,
      country: json['country'] as String,
      formatAddress: json['formatAddress'] as String,
      province: json['province'] as String,
      towncode: json['towncode'] as String,
      township: json['township'] as String,
      pois: (json['pois'] as List)
          ?.map((e) => e == null
              ? null
              : LocationPois.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$LocationGeocodeToJson(LocationGeocode instance) =>
    <String, dynamic>{
      'towncode': instance.towncode,
      'township': instance.township,
      'adCode': instance.adCode,
      'cityCode': instance.cityCode,
      'country': instance.country,
      'formatAddress': instance.formatAddress,
      'province': instance.province,
      'pois': instance.pois
    };
