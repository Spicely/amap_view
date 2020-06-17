// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'index.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationPois _$LocationPoisFromJson(Map<String, dynamic> json) {
  return LocationPois(
      json['adcode'] as String,
      json['address'] as String,
      json['businessArea'] as String,
      json['city'] as String,
      json['citycode'] as String,
      json['province'] as String,
      json['direction'] as String,
      (json['distance'] as num)?.toDouble(),
      json['district'] as String,
      json['email'] as String,
      json['gridcode'] as String,
      json['hasIndoorMap'] as bool,
      json['name'] as String,
      json['parkingType'] as String,
      json['pcode'] as String,
      json['postcode'] as String,
      json['shopID'] as String,
      json['tel'] as String,
      json['type'] as String,
      json['typecode'] as String,
      json['uid'] as String,
      json['website'] as String);
}

Map<String, dynamic> _$LocationPoisToJson(LocationPois instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'type': instance.type,
      'typecode': instance.typecode,
      'address': instance.address,
      'tel': instance.tel,
      'distance': instance.distance,
      'parkingType': instance.parkingType,
      'shopID': instance.shopID,
      'postcode': instance.postcode,
      'website': instance.website,
      'email': instance.email,
      'province': instance.province,
      'pcode': instance.pcode,
      'city': instance.city,
      'citycode': instance.citycode,
      'district': instance.district,
      'adcode': instance.adcode,
      'gridcode': instance.gridcode,
      'direction': instance.direction,
      'hasIndoorMap': instance.hasIndoorMap,
      'businessArea': instance.businessArea
    };
