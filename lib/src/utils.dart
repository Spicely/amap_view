part of amap_view;

class AmapUtils {
  static const MethodChannel _channel = const MethodChannel('plugins.laoqiu.com/amap_view_utils');

  /// 两点间的直线距离计算
  static Future<double> calculateLineDistance(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('utils#calculateLineDistance', {
      "start": start?.toMap(),
      "end": end?.toMap(),
    });
  }

  /// 面积计算
  static Future<double> calculateArea(LatLng start, LatLng end) async {
    return await _channel.invokeMethod('utils#calculateArea', {
      "start": start?.toMap(),
      "end": end?.toMap(),
    });
  }

  /// 将其他坐标转换成高德坐标
  static Future<LatLng> converter(LatLng sourceLatLng, CoordType coordType) async {
    dynamic latlng = await _channel.invokeMethod('utils#converter', {
      "sourceLatLng": sourceLatLng?.toMap(),
      "coordType": coordType.index,
    });
    return LatLng.fromJson(latlng);
  }
}
