part of amap_view;

class AMapController {
  final MethodChannel channel;
  final _AmapViewState _mapState;

  AMapController._(this.channel, this._mapState) : assert(channel != null) {
    channel.setMethodCallHandler(_handleMethodCall);
  }

  static Future<AMapController> init(int id, _AmapViewState state) async {
    assert(id != null);
    final MethodChannel channel =
        MethodChannel('plugins.laoqiu.com/amap_view_$id');
    await channel.invokeMethod('map#waitForMap');
    return AMapController._(channel, state);
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'map#onTap':
        _mapState.onTap(LatLng.fromJson(call.arguments['position']));
        break;
      case 'marker#onTap':
        _mapState.onMarkerTap(call.arguments['markerId']);
        break;
      case 'infoWindow#onTap':
        _mapState.onInfoWindowTap(call.arguments['markerId']);
        break;
      case 'polyline#onTap':
        _mapState.onPolylineTap(call.arguments['polylineId']);
        break;
      case 'poi#onTap':
        // poi点击时回调
        break;
      case 'camera#onMove':
        if (_mapState.widget.onCameraMove != null)
          _mapState.widget
              .onCameraMove(CameraPosition.fromMap(call.arguments['position']));
        break;
      case 'camera#onIdle':
        if (_mapState.widget.onCameraIdle != null)
          _mapState.widget
              .onCameraIdle(CameraPosition.fromMap(call.arguments['position']));
        break;
      default:
        throw MissingPluginException();
    }
  }

  Future<void> _updateMapOptions(Map<String, dynamic> optionsUpdate) async {
    assert(optionsUpdate != null);
    await channel.invokeMethod('map#update', <String, dynamic>{'options': optionsUpdate});
  }

  Future<void> _updateMarkers(_MarkerUpdates markerUpdates) async {
    assert(markerUpdates != null);
    await channel.invokeMethod('markers#update', markerUpdates.toMap());
  }

  Future<void> _updatePolylines(_PolylineUpdates polylineUpdates) async {
    assert(polylineUpdates != null);
    await channel.invokeMethod('polylines#update', polylineUpdates.toMap());
  }

  /// 更新地图视图状态
  Future<void> moveCamera(CameraUpdate cameraUpdate) async {
    assert(cameraUpdate != null);
    await channel.invokeMethod('camera#update', cameraUpdate.toMap());
  }
}
