part of amap_view;

typedef void MapCreatedCallback(AMapController controller);
typedef void CameraPositionCallback(CameraPosition position);
typedef void ArgumentCallback<T>(T argument);

const _viewType = "plugins.muka.com/amap_view";

class AmapView extends StatefulWidget {
  AmapView({
    Key key,
    this.initialCameraPosition,
    this.mapType = MapType.NORMAL,
    this.myLocationStyle = MyLocationStyle.LOCATION_TYPE_SHOW,
    this.myLocationEnabled = false,
    this.setMyLocationButtonEnabled = false,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.scaleControlsEnabled = true,
    this.tiltGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.markers,
    this.polylines,
    this.onMapCreated,
    this.onCameraMove,
    this.onCameraIdle,
    this.onTap,
    this.hitTestBehavior = PlatformViewHitTestBehavior.opaque,
    this.layoutDirection,
  }) : super(key: key);

  /// 地图类型
  final MapType mapType;

  /// 当前位置的类型，仅在[myLocationEnabled]为true时有效 (android only)
  final MyLocationStyle myLocationStyle;

  /// 初始化地图位置
  final CameraPosition initialCameraPosition;

  /// 设置地图是否显示当前位置，默认为false
  final bool myLocationEnabled;

  /// 设置地图是否可以通过手势滑动，默认为true
  final bool scrollGesturesEnabled;

  /// 设置地图是否可以通过手势进行旋转，默认为true
  final bool rotateGesturesEnabled;

  /// 设置地图是否显示比例尺，默认为false
  final bool scaleControlsEnabled;

  /// 设置地图是否可以通过手势倾斜（3D效果），默认为true (android only)
  final bool tiltGesturesEnabled;

  /// 设置地图是否允许缩放，默认为true
  final bool zoomControlsEnabled;

  /// 设置是否显示跳转当前位置按钮，仅在[myLocationEnabled]为true时有效
  final bool setMyLocationButtonEnabled;

  /// 地图点标志
  final Set<Marker> markers;

  /// 折线
  final Set<Polyline> polylines;

  /// 地图创建成功回调
  final MapCreatedCallback onMapCreated;

  /// 地图镜头开始移动回调
  // final VoidCallback onCameraMoveStarted;

  /// 地图镜头改变过程回调
  final CameraPositionCallback onCameraMove;

  /// 地图镜头移动结束回调
  final CameraPositionCallback onCameraIdle;

  /// 地图点击事件回调
  final ArgumentCallback<LatLng> onTap;

  /// 下面两条暂不知用处
  final TextDirection layoutDirection;

  final PlatformViewHitTestBehavior hitTestBehavior;

  @override
  State<StatefulWidget> createState() {
    return _AmapViewState();
  }
}

class _AmapViewState extends State<AmapView> {
  final Completer<AMapController> _controller = Completer<AMapController>();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  Map<PolylineId, Polyline> _polylines = <PolylineId, Polyline>{};

  _AMapOptions _mapOptions;

  void _updateOptions() async {
    final _AMapOptions newOptions = _AMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates = _mapOptions.updatesMap(newOptions);
    if (updates.isNotEmpty) {
      final AMapController controller = await _controller.future;
      controller._updateMapOptions(updates);
    }
  }

  void _updateMarkers() async {
    final AMapController controller = await _controller.future;
    controller._updateMarkers(_MarkerUpdates.from(_markers.values.toSet(), widget.markers));
    _markers = _keyByMarkerId(widget.markers);
  }

  void _updatePolylines() async {
    // final AMapController controller = await _controller.future;
    // controller._updatePolylines(
    //     _PolylineUpdates.from(_polylines.values.toSet(), widget.polylines));
    // _polylines = _keyByPolylineId(widget.polylines);
  }

  @override
  void initState() {
    super.initState();
    _mapOptions = _AMapOptions.fromWidget(widget);
    _markers = _keyByMarkerId(widget.markers);
    _polylines = _keyByPolylineId(widget.polylines);
  }

  @override
  void didUpdateWidget(AmapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateMarkers();
    _updatePolylines();
    _updateOptions();
  }

  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    ].toSet();

    final Map<String, dynamic> creationParams = <String, dynamic>{
      "options": _mapOptions.toMap(),
      "markersToAdd": _serializeMarkerSet(widget.markers),
      "polylinesToAdd": _serializePolylineSet(widget.polylines),
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: widget.layoutDirection,
        hitTestBehavior: widget.hitTestBehavior,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        onPlatformViewCreated: onPlatformViewCreated,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        layoutDirection: widget.layoutDirection,
        hitTestBehavior: widget.hitTestBehavior,
      );
    }
  }

  Future<void> onPlatformViewCreated(int id) async {
    final AMapController controller = await AMapController.init(id, this);
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }

  void onTap(LatLng position) {
    assert(position != null);
    widget.onTap(position);
  }

  void onMarkerTap(String markerIdParam) {
    assert(markerIdParam != null);
    final MarkerId markerId = MarkerId(markerIdParam);
    _markers[markerId].onTap();
  }

  void onInfoWindowTap(String markerIdParam) {
    assert(markerIdParam != null);
    final MarkerId markerId = MarkerId(markerIdParam);
    _markers[markerId].infoWindow.onTap();
  }

  void onPolylineTap(String polylineIdParam) {
    assert(polylineIdParam != null);
    final PolylineId polylineId = PolylineId(polylineIdParam);
    _polylines[polylineId].onTap();
  }
}

class _AMapOptions {
  _AMapOptions({
    @required this.cameraPosition,
    this.mapType = MapType.NORMAL,
    this.myLocationStyle = MyLocationStyle.LOCATION_TYPE_SHOW,
    this.myLocationEnabled = false,
    this.setMyLocationButtonEnabled = false,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.scaleControlsEnabled = false,
    this.tiltGesturesEnabled = true,
    this.zoomControlsEnabled = true,
  });

  final MapType mapType;

  final MyLocationStyle myLocationStyle;

  final CameraPosition cameraPosition;

  final bool myLocationEnabled;

  final bool setMyLocationButtonEnabled;

  final bool scrollGesturesEnabled;

  final bool rotateGesturesEnabled;

  final bool scaleControlsEnabled;

  final bool tiltGesturesEnabled;

  final bool zoomControlsEnabled;

  static _AMapOptions fromWidget(AmapView map) {
    return _AMapOptions(
      mapType: map.mapType,
      myLocationStyle: map.myLocationStyle,
      cameraPosition: map.initialCameraPosition,
      myLocationEnabled: map.myLocationEnabled,
      scrollGesturesEnabled: map.scrollGesturesEnabled,
      rotateGesturesEnabled: map.rotateGesturesEnabled,
      scaleControlsEnabled: map.scaleControlsEnabled,
      tiltGesturesEnabled: map.tiltGesturesEnabled,
      zoomControlsEnabled: map.zoomControlsEnabled,
      setMyLocationButtonEnabled: map.setMyLocationButtonEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> options = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        options[fieldName] = value;
      }
    }

    addIfNonNull("mapType", mapType?.index);
    addIfNonNull("myLocationStyle", myLocationStyle?.index);
    addIfNonNull("camera", cameraPosition?.toMap());
    addIfNonNull("myLocationEnabled", myLocationEnabled);
    addIfNonNull("rotateGesturesEnabled", rotateGesturesEnabled);
    addIfNonNull("scrollGesturesEnabled", scrollGesturesEnabled);
    addIfNonNull("scaleControlsEnabled", scaleControlsEnabled);
    addIfNonNull("tiltGesturesEnabled", tiltGesturesEnabled);
    addIfNonNull("zoomControlsEnabled", zoomControlsEnabled);
    addIfNonNull("setMyLocationButtonEnabled", setMyLocationButtonEnabled);

    return options;
  }

  String toEncodedJson() {
    return jsonEncode(toMap());
  }

  Map<String, dynamic> updatesMap(_AMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()..removeWhere((String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
