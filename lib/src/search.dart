part of amap_search;

class AmapSearch {
  static const MethodChannel _channel = const MethodChannel('plugins.muka.com/amap_search');

  /// 地址转换
  static Future<LatLng> searchKeyword(String keyword) async {
    
    // return LatLng.fromJson(data);
  }
}