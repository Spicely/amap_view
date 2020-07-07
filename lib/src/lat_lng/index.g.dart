// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LatLng _$LatLngFromJson(Map<String, dynamic> json) {
  return LatLng(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$LatLngToJson(LatLng instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
