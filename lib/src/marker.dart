part of amap_view;

dynamic _offsetToJson(Offset offset) {
  return offset != null ? <dynamic>[offset.dx, offset.dy] : null;
}

class InfoWindow {
  const InfoWindow({
    this.title,
    this.snippet,
    this.anchor = const Offset(0, 0),
    this.onTap,
  });

  /// 无内容窗口
  static const InfoWindow noText = InfoWindow();

  /// 标题
  final String title;

  /// 可选的文字片段
  final String snippet;

  /// 锚点比例
  final Offset anchor;

  /// 点击事件回调 [InfoWindow].
  final VoidCallback onTap;

  /// 从实例复制一个新的 [InfoWindow] 对象
  InfoWindow copyWith({
    String titleParam,
    String snippetParam,
    Offset anchorParam,
    VoidCallback onTapParam,
  }) {
    return InfoWindow(
      title: titleParam ?? title,
      snippet: snippetParam ?? snippet,
      anchor: anchorParam ?? anchor,
      onTap: onTapParam ?? onTap,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent('title', title);
    addIfPresent('snippet', snippet);
    addIfPresent('anchor', _offsetToJson(anchor));

    return _data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final InfoWindow typedOther = other;
    return title == typedOther.title && snippet == typedOther.snippet && anchor == typedOther.anchor;
  }

  @override
  int get hashCode => hashValues(title.hashCode, snippet, anchor);

  @override
  String toString() {
    return 'InfoWindow{title: $title, snippet: $snippet, anchor: $anchor}';
  }
}

@immutable
class MarkerId {
  MarkerId(this.value) : assert(value != null);

  /// value of the [MarkerId].
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MarkerId typedOther = other;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'MarkerId{value: $value}';
  }
}

@immutable
class Marker {
  Marker({
    @required this.markerId,
    this.alpha = 1.0,
    this.anchor = const Offset(0.5, 1.0),
    this.draggable = false,
    this.flat = false,
    this.icon = BitmapDescriptor.defaultMarker,
    this.infoWindow = InfoWindow.noText,
    this.infoWindowEnable = true,
    this.position,
    this.rotation = 0.0,
    this.visible = true,
    this.zIndex = 0.0,
    this.onTap,
    this.showInfoWindow,
  }) : assert(alpha == null || (0.0 <= alpha && alpha <= 1.0));

  final MarkerId markerId;

  /// 设置[Marker][InfoWindow]显示
  /// 
  /// 只能显示一个 
  /// 
  /// 如果新增 为true则显示新增的
  /// 
  /// 更新时 参数没有改变将不会被触发
  final bool showInfoWindow;

  /// 设置[Marker]透明度
  final double alpha;

  /// 设置[Marker]的图片旋转角度，从正北开始，逆时针计算
  final double rotation;

  /// 设置[Marker]锚点比例
  final Offset anchor;

  /// 设置[Marker]是否允许拖拽
  final bool draggable;

  /// 设置[Marker]是否平贴在地图上
  final bool flat;

  /// 设置[Marker]是否显示
  final bool visible;

  /// 设置[Marker]的z轴值
  final double zIndex;

  /// 设置[Marker]的位置
  final LatLng position;

  final BitmapDescriptor icon;

  /// 设置[Marker]覆盖物的[InfoWindow]
  final InfoWindow infoWindow;

  /// 设置[Marker]是否显示[InfoWindow]，默认显示
  final bool infoWindowEnable;

  final VoidCallback onTap;

  Marker copyWith({
    double alphaParam,
    Offset anchorParam,
    bool draggableParam,
    bool flatParam,
    BitmapDescriptor iconParam,
    InfoWindow infoWindowParam,
    LatLng positionParam,
    double rotationParam,
    bool visibleParam,
    double zIndexParam,
    VoidCallback onTapParam,
    bool showInfoWindow,
  }) {
    return Marker(
      markerId: markerId,
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      draggable: draggableParam ?? draggable,
      flat: flatParam ?? flat,
      icon: iconParam ?? icon,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      onTap: onTapParam ?? onTap,
      showInfoWindow: showInfoWindow,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent('markerId', markerId.value);
    addIfPresent('alpha', alpha);
    addIfPresent('anchor', _offsetToJson(anchor));
    addIfPresent('draggable', draggable);
    addIfPresent('flat', flat);
    addIfPresent('rotation', rotation);
    addIfPresent('icon', icon?.toMap());
    addIfPresent('infoWindow', infoWindow?.toMap());
    addIfPresent('infoWindowEnable', infoWindowEnable);
    addIfPresent('position', position?.toJson());
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('showInfoWindow', showInfoWindow);
    return _data;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Marker typedOther = other;
    return markerId == typedOther.markerId;
  }

  @override
  int get hashCode => markerId.hashCode;

  @override
  String toString() {
    return 'Marker{markerId: $markerId, alpha: $alpha, anchor: $anchor, '
        'draggable: $draggable, flat: $flat, '
        'icon: $icon, infoWindow: $infoWindow, position: $position, '
        'visible: $visible, zIndex: $zIndex, onTap: $onTap}';
  }
}

Map<MarkerId, Marker> _keyByMarkerId(Iterable<Marker> markers) {
  if (markers == null) {
    return <MarkerId, Marker>{};
  }
  return Map<MarkerId, Marker>.fromEntries(markers.map((Marker marker) => MapEntry<MarkerId, Marker>(marker.markerId, marker)));
}

List<dynamic> _serializeMarkerSet(Set<Marker> markers) {
  if (markers == null) {
    return null;
  }
  return markers.map<dynamic>((Marker m) => m.toMap()).toList();
}

class _MarkerUpdates {
  /// Computes [_MarkerUpdates] given previous and current [Marker]s.
  _MarkerUpdates.from(Set<Marker> previous, Set<Marker> current) {
    if (previous == null) {
      previous = Set<Marker>.identity();
    }

    if (current == null) {
      current = Set<Marker>.identity();
    }

    final Map<MarkerId, Marker> previousMarkers = _keyByMarkerId(previous);
    final Map<MarkerId, Marker> currentMarkers = _keyByMarkerId(current);

    final Set<MarkerId> prevMarkerIds = previousMarkers.keys.toSet();
    final Set<MarkerId> currentMarkerIds = currentMarkers.keys.toSet();

    Marker idToCurrentMarker(MarkerId id) {
      return currentMarkers[id];
    }

    final Set<MarkerId> _markerIdsToRemove = prevMarkerIds.difference(currentMarkerIds);

    final Set<Marker> _markersToAdd = currentMarkerIds.difference(prevMarkerIds).map(idToCurrentMarker).toSet();

    final Set<Marker> _markersToChange = currentMarkerIds.intersection(prevMarkerIds).map(idToCurrentMarker).toSet();

    markersToAdd = _markersToAdd;
    markerIdsToRemove = _markerIdsToRemove;
    markersToChange = _markersToChange;
  }

  Set<Marker> markersToAdd;
  Set<MarkerId> markerIdsToRemove;
  Set<Marker> markersToChange;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> updateMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        updateMap[fieldName] = value;
      }
    }

    addIfNonNull('markersToAdd', _serializeMarkerSet(markersToAdd));
    addIfNonNull('markersToChange', _serializeMarkerSet(markersToChange));
    addIfNonNull('markerIdsToRemove', markerIdsToRemove.map<dynamic>((MarkerId m) => m.value).toList());

    return updateMap;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final _MarkerUpdates typedOther = other;
    return setEquals(markersToAdd, typedOther.markersToAdd) &&
        setEquals(markerIdsToRemove, typedOther.markerIdsToRemove) &&
        setEquals(markersToChange, typedOther.markersToChange);
  }

  @override
  int get hashCode => hashValues(markersToAdd, markerIdsToRemove, markersToChange);

  @override
  String toString() {
    return '_MarkerUpdates{markersToAdd: $markersToAdd, '
        'markerIdsToRemove: $markerIdsToRemove, '
        'markersToChange: $markersToChange}';
  }
}
