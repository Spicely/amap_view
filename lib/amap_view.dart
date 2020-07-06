import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum MapType {
  /// 普通地图
  NORMAL,

  /// 卫星地图
  SATELLITE,

  /// 夜间模式
  NIGHT,

  /// 导航模式
  NAVI,

  /// 公交模式
  BUS,
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
const _viewType = "plugins.muka.com/amap_view";

class AmapView extends StatefulWidget {
  AmapView({
    Key key,
    this.mapType,
    this.showsIndoorMap = false,
  }) : super(key: key);

  /// 地图类型
  final MapType mapType;

  /// 室内地图 默认[false]
  final bool showsIndoorMap;

  @override
  _AmapViewState createState() => _AmapViewState();
}

class _AmapViewState extends State<AmapView> {
  @override
  Widget build(BuildContext context) {
    final gestureRecognizers = <Factory<OneSequenceGestureRecognizer>>[
      Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
    ].toSet();

    // final Map<String, dynamic> creationParams = <String, dynamic>{
    //   "options": _mapOptions.toMap(),
    //   // "markersToAdd": _serializeMarkerSet(widget.markers),
    //   // "polylinesToAdd": _serializePolylineSet(widget.polylines),
    // };

    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        // onPlatformViewCreated: onPlatformViewCreated,
        // creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    } else {
      return UiKitView(
        viewType: _viewType,
        gestureRecognizers: gestureRecognizers,
        // onPlatformViewCreated: onPlatformViewCreated,
        // creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
        // layoutDirection: widget.layoutDirection,
        // hitTestBehavior: widget.hitTestBehavior,
      );
    }
  }
}
