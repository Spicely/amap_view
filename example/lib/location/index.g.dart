// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Location _$LocationFromJson(Map<String, dynamic> json) {
  return Location(
      latitude: (json['latitude'] as num)?.toDouble(),
      longitude: (json['longitude'] as num)?.toDouble(),
      accuracy: (json['accuracy'] as num)?.toDouble(),
      address: json['address'] as String,
      city: json['city'] as String,
      country: json['country'] as String,
      district: json['district'] as String,
      street: json['street'] as String,
      geocode: json['geocode'] == null
          ? null
          : LocationGeocode.fromJson(json['geocode'] as Map<String, dynamic>));
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'country': instance.country,
      'city': instance.city,
      'street': instance.street,
      'district': instance.district,
      'accuracy': instance.accuracy,
      'geocode': instance.geocode
    };
