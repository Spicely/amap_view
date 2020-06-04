part of amap_view;

enum MapType {
  none,

  // 普通地图
  normal,

  // 卫星地图
  satellite,

  // 夜间模式
  night,

  // 导航模式
  navi,

  // 公交模式
  bus,
}

enum MyLocationStyle {
  // 只定位
  LOCATION_TYPE_SHOW,

  // 定位、且将视角移动到地图中心点
  LOCATION_TYPE_LOCATE,

  // 定位、且将视角移动到地图中心点，定位点跟随设备移动
  LOCATION_TYPE_FOLLOW,

  // 定位、且将视角移动到地图中心点，地图依照设备方向旋转，定位点会跟随设备移动
  LOCATION_TYPE_MAP_ROTATE,

  // 定位、且将视角移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动
  LOCATION_TYPE_LOCATION_ROTATE,

  // 定位、但不会移动到地图中心点，定位点依照设备方向旋转，并且会跟随设备移动
  LOCATION_TYPE_LOCATION_ROTATE_NO_CENTER,

  // 定位、但不会移动到地图中心点，并且会跟随设备移动
  LOCATION_TYPE_FOLLOW_NO_CENTER,

  // 定位、但不会移动到地图中心点，地图依照设备方向旋转，并且会跟随设备移动
  LOCATION_TYPE_MAP_ROTATE_NO_CENTER,
}

enum NaviType {
  /// 驾车
  driver,

  /// 步行
  walk,

  /// 骑行
  ride,
}

enum DistanceType {
  /// 驾车
  driver,

  /// 直线
  line,
  
}

enum LatLntType {
  amap,
  gps,
}

/// 坐标系
enum CoordType {
  /// 百度
  baidu,

  /// 阿里云
  aliyun,

  /// 谷歌
  google,

  /// GPS
  gps,

  /// MAPABC
  mapabc,

  /// MAPBAR
  mapbar,

  /// SOSO地图
  sosomap,
}

class Avatar {
  Avatar({
    @required this.url,
    this.size = const Size(120, 120),
    this.offset = const Offset(0, 0),
    this.radius = 60,
  })  : assert(url != null),
        assert(size != null),
        assert(offset != null),
        assert(radius != null);

  final String url;
  final Offset offset;
  final Size size;
  final int radius;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent("url", url);
    addIfPresent("offset", [offset.dx, offset.dy]);
    addIfPresent("size", [size.width.toInt(), size.height.toInt()]);
    addIfPresent("radius", radius);

    return _data;
  }
}

class Label {
  Label({
    @required this.text,
    this.size = 22.0,
    this.color = Colors.blue,
    this.offset = const Offset(0, 0)
  }) : assert(text != null);

  final String text;
  final double size;
  final Color color;
  final Offset offset;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent("text", text);
    addIfPresent("offset", [offset.dx, offset.dy]);
    addIfPresent("size", size);
    // addIfPresent("color", color.value);
    addIfPresent("color", [color.value >> 16 & 0xFF, color.value >> 8 & 0xFF, color.value & 0xFF]);

    return _data;
  }
}