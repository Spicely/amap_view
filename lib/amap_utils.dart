import 'dart:async';

import 'package:flutter/services.dart';

class AmapUtils {
  static const MethodChannel _channel =
      const MethodChannel('amap_utils');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
