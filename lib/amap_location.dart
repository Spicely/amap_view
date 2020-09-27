library amap_location;

import 'dart:async';

import 'package:amap_core/amap_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

export 'package:amap_core/amap_core.dart';

/// 仅Android可用
enum AmapLocationMode {
  /// 高精度模式
  HIGHT_ACCURACY,

  /// 低功耗模式
  BATTERY_SAVING,

  /// 仅设备模式,不支持室内环境的定位
  DEVICE_SENSORS,
}

/// 仅IOS可用
enum AmapLocationAccuracy {
  /// 最快 精确度最底 约秒到
  THREE_KILOMETERS,

  /// 精确度较低 约秒到
  KILOMETER,

  /// 精确度较低 约2s
  HUNDREE_METERS,

  /// 精确度较高 约5s
  NEAREST_TENMETERS,

  /// 最慢 精确度最高 约8s
  BEST,
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
  ///
  /// androidMode 定位方式 [ 仅适用android ]
  ///
  /// iosAccuracy 精确度 [ 仅适用ios ]
  static Future<Location> fetch({
    AmapLocationMode androidMode = AmapLocationMode.HIGHT_ACCURACY,
    AmapLocationAccuracy iosAccuracy = AmapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    dynamic location = await _channel.invokeMethod('fetch', {
      'mode': androidMode.index,
      'accuracy': iosAccuracy.index,
    });
    return Location.fromJson(location);
  }

  /// 持续定位
  ///
  /// time 间隔时间 默认 2000
  ///
  /// mode 定位方式 [ 仅适用android ]
  ///
  /// geocode 返回逆编码信息
  ///
  /// accuracy 精确度 [ 仅适用ios ]
  static Future<Future<Null> Function()> start({
    @required AmapLocationListen listen,
    AmapLocationMode mode = AmapLocationMode.HIGHT_ACCURACY,
    int time,
    AmapLocationAccuracy accuracy = AmapLocationAccuracy.THREE_KILOMETERS,
  }) async {
    await _channel.invokeMethod('start', {
      'mode': mode.index,
      'time': time ?? 2000,
      'accuracy': accuracy.index,
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
