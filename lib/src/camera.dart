part of amap_view;

class CameraPosition {
  const CameraPosition({
    @required this.target,
    this.bearing = 0.0,
    this.tilt = 0.0,
    this.zoom = 0.0,
  })  : assert(bearing != null),
        assert(zoom != null),
        assert(tilt != null);

  /// 可视区域指向的方向，以角度为单位，从正北向逆时针方向计算，从0 度到360 度
  final double bearing;

  /// 目标位置的屏幕中心点经纬度坐标 [LatLng]
  final LatLng target;

  /// 目标可视区域的倾斜度，以角度为单位
  final double tilt;

  /// 目标可视区域的缩放级别
  final double zoom;

  Map<String, dynamic> toMap() {
    return {
      'bearing': bearing,
      'target': target.toMap(),
      'tilt': tilt,
      'zoom': zoom,
    };
  }

  static CameraPosition fromMap(dynamic json) {
    if (json == null) {
      return null;
    }
    return CameraPosition(
      bearing: json['bearing'],
      target: LatLng.fromJson(json['target']),
      tilt: json['tilt'],
      zoom: json['zoom'],
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final CameraPosition typedOther = other;
    return bearing == typedOther.bearing &&
        target == typedOther.target &&
        tilt == typedOther.tilt &&
        zoom == typedOther.zoom;
  }

  @override
  int get hashCode => hashValues(bearing, target, tilt, zoom);

  @override
  String toString() =>
      'CameraPosition(bearing: $bearing, target: $target, tilt: $tilt, zoom: $zoom)';
}

/// [CameraUpdate]描述地图状态将要发生的变化
class CameraUpdate {
  CameraUpdate._(this._data);

  /// 给地图设置一个新的状态
  static CameraUpdate newCameraPosition(CameraPosition cameraPosition) {
    return CameraUpdate._(
      <dynamic>['newCameraPosition', cameraPosition.toMap()],
    );
  }

  /// 设置地图的中心点
  static CameraUpdate newLatLng(LatLng latLng) {
    return CameraUpdate._(<dynamic>['newLatLng', latLng.toMap()]);
  }

  /// 设置显示在规定屏幕范围内的地图经纬度范围
  static CameraUpdate newLatLngBounds(LatLngBounds bounds, double padding) {
    return CameraUpdate._(<dynamic>[
      'newLatLngBounds',
      bounds.toMap(),
      padding,
    ]);
  }

  /// 设置地图中心点以及缩放级别
  static CameraUpdate newLatLngZoom(LatLng latLng, double zoom) {
    return CameraUpdate._(
      <dynamic>['newLatLngZoom', latLng.toMap(), zoom],
    );
  }

  /// 按像素移动地图中心点
  static CameraUpdate scrollBy(double dx, double dy) {
    return CameraUpdate._(
      <dynamic>['scrollBy', dx, dy],
    );
  }

  /// 根据给定增量缩放地图级别，在当前地图显示的级别基础上加上这个增量
  static CameraUpdate zoomBy(double amount, [Offset focus]) {
    if (focus == null) {
      return CameraUpdate._(<dynamic>['zoomBy', amount]);
    } else {
      return CameraUpdate._(<dynamic>[
        'zoomBy',
        amount,
        <double>[focus.dx, focus.dy],
      ]);
    }
  }

  /// 放大地图缩放级别，在当前地图显示的级别基础上加1
  static CameraUpdate zoomIn() {
    return CameraUpdate._(<dynamic>['zoomIn']);
  }

  /// 缩小地图缩放级别，在当前地图显示的级别基础上减1
  static CameraUpdate zoomOut() {
    return CameraUpdate._(<dynamic>['zoomOut']);
  }

  /// 设置地图缩放级别
  static CameraUpdate zoomTo(double zoom) {
    return CameraUpdate._(<dynamic>['zoomTo', zoom]);
  }

  final dynamic _data;

  dynamic toMap() => _data;
}
