export './location.dart';

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './location.dart';

/// 仅Android可用
enum AmapLocationMode {
  /// 高精度模式
  HIGHT_ACCURACY,

  /// 低功耗模式
  BATTERY_SAVING,

  /// 仅设备模式,不支持室内环境的定位
  DEVICE_SENSORS,
}

enum ConvertType {
  /// GPS
  GPS,

  /// 百度
  BAIDU,

  /// Google
  GOOGLE,
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
  static Future<Future<Null> Function()> start(
      {@required AmapLocationListen listen, AmapLocationMode mode = AmapLocationMode.HIGHT_ACCURACY, int time}) async {
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
  static Future<void> enableBackground({@required String title, @required String label, @required String assetName, bool vibrate}) async {
    assert(title != null);
    assert(label != null);
    assert(assetName != null);
    await _channel.invokeMethod('enableBackground', {'title': title, 'label': label, 'assetName': assetName, 'vibrate': vibrate ?? true});
  }

  /// 关闭后台服务
  static Future<void> disableBackground() async {
    await _channel.invokeMethod('disableBackground');
  }

  // /// 地址转换
  // static Future<LatLng> convert({
  //   @required LatLng latLng,
  //   ConvertType type = ConvertType.GPS,
  // }) async {
  //   assert(latLng != null);
  //   dynamic data =  await _channel.invokeMethod('convert', {
  //     'latlng': latLng.toMap(),
  //     'type': type.index,
  //   });
  //   return LatLng.fromJson(data);
  // }
}

class LatLng {
  const LatLng(this.latitude, this.longitude)
      : assert(latitude != null),
        assert(longitude != null);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return {"latitude": latitude, "longitude": longitude};
  }

  static LatLng fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLng(json["latitude"], json["longitude"]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}
