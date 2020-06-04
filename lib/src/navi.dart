part of amap_view;

class AmapNavi {
  static const MethodChannel _channel =
      const MethodChannel('plugins.laoqiu.com/amap_view_navi');

  /// 导航
  static Future<void> showRoute({
    Poi start,
    Poi end,
    NaviType naviType,
    /// 最多三个
    List<LatLng> wayList,
  }) async {
    assert(wayList == null || wayList.length <= 3);
    await _channel.invokeMethod('navi#showRoute', {
      "naviType": naviType.index ?? 0,
      "start": start?.toMap(),
      "end": end?.toMap(),
      "wayList": wayList?.map((i) => i.toMap()),
    });
  }
}