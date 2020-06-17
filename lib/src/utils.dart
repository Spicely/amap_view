part of amap_search;

enum ConvertType {
  /// GPS
  GPS,

  /// 百度
  BAIDU,

  /// Google
  GOOGLE,
}

class AmapUtils {
  static const MethodChannel _channel = const MethodChannel('plugins.muka.com/amap_utils');

  /// 地址转换
  static Future<LatLng> convert(LatLng latLng, {ConvertType type = ConvertType.GPS}) async {
    dynamic data = await _channel.invokeMethod('convert', {
      'latlng': latLng.toMap(),
      'type': type.index,
    });
    return LatLng.fromJson(data);
  }

  /// 直线距离计算
  static Future<double> calculateLineDistance(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('calculateLineDistance', {
      "start": start?.toMap(),
      "end": end?.toMap(),
    });
  }

  /// 面积计算
  static Future<double> calculateArea(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('calculateArea', {
      "start": start?.toMap(),
      "end": end?.toMap(),
    });
  }
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
