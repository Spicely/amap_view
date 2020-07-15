part of amap_navi;

enum NaviType {
  /// 驾车
  DRIVER,

  /// 步行
  WALK,

  /// 骑行
  RIDE,
}

class Poi {
  Poi(this.name, this.target, this.s1)
      : assert(name != null),
        assert(target != null);

  final String name;
  final LatLng target;
  final String s1;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent("name", name);
    addIfPresent("target", target.toJson());
    addIfPresent("s1", s1);

    return _data;
  }
}

class AmapNavi {
  static const MethodChannel _channel = const MethodChannel('plugins.muka.com/amap_navi');

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
      "wayList": wayList?.map((i) => i.toJson()),
    });
  }
}
