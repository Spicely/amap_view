import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum AmapLocationMode {
  /// 高精度模式
  HIGHT_ACCURACY,

  /// 低功耗模式
  BATTERY_SAVING,

  /// 仅设备模式,不支持室内环境的定位
  DEVICE_SENSORS,
}

typedef void AmapLocationListen(Location location);

class AmapLocation {
  static const _channel = MethodChannel('plugins.muka.com/amap_location');

  static const _event = EventChannel('plugins.muka.com/amap_location_event');

  /// 单次定位
  static Future<Location> fetch({
    AmapLocationMode mode = AmapLocationMode.HIGHT_ACCURACY,
  }) async {
    dynamic location = await _channel.invokeMethod('fetch', {
      'mode': mode.index,
    });
    return Location.fromJson(location);
  }

  /// 持续定位
  /// 间隔时间 默认 2000
  static Future<Future<Null> Function()> start({
    @required AmapLocationListen listen,
    AmapLocationMode mode = AmapLocationMode.HIGHT_ACCURACY,
    int time
  }) async {
    await _channel.invokeMethod('start', {
      'mode': mode.index,
      'time': time ?? 2000,
    });
    _event.receiveBroadcastStream().listen((dynamic data) {
      listen(Location.fromJson(data));
    });
    return () async {
      await _channel.invokeMethod('stop');
    };
  }

  /// 启动后台服务
  static Future<void> enableBackground({
    @required String title,
    @required String label,
    @required String assetName,
    bool vibrate
  }) async {
    assert(title != null);
    assert(label != null);
    assert(assetName != null);
    await _channel.invokeMethod('enableBackground', {
      'title': title,
      'label': label,
      'assetName': assetName,
      'vibrate': vibrate ?? true
    });
  }

  /// 关闭后台服务
  static Future<void> disableBackground() async {
    await _channel.invokeMethod('disableBackground');
  }
}

class Location {
  final double latitude;

  final double longitude;

  final String address;

  final String country;

  final String city;

  final String street;

  final String district;

  final double accuracy;

  Location({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.address,
    this.city,
    this.country,
    this.district,
    this.street,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) => _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

Location _$LocationFromJson(Map<dynamic, dynamic> json) {
  return Location(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    accuracy: json['accuracy'] as num,
    address: json['address'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    district: json['district'] as String,
    street: json['street'] as String,
  );
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
    };
