//
//  AmapViewController.swift
//  amap_view
//
//  TODO 仍有两个错误未解决:
//  1. libMobileGestalt MobileGestalt.c:890: MGIsDeviceOneOfType is not supported on this platform.
//  2. 当双击或拖移时，有机率报错并无响应，但不会崩溃:
//  Runner[7237:131747] [VERBOSE-2:ui_dart_state.cc(148)] Unhandled Exception: 'package:flutter/src/gestures/converter.dart': Failed assertion: line 156 pos 20: '!state.down': is not true.
//  2019/4/24: 官方未merge解决方案，估计会在近期更新 https://github.com/flutter/engine/pull/8685/
//  2019/5/6: 最近一次flutter更新后此问题消失，待观察
//
//  Created by QiuLiang Wang on 2019/4/23.
//
import Flutter
import AMapNaviKit

class AmapViewController: NSObject, FlutterPlatformView, MAMapViewDelegate, AmapOptionsSink {
    
    private var _frame: CGRect
    private var mapView: MAMapView
    private var channel: FlutterMethodChannel
    private var markerController: MarkerController
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger messenger: FlutterBinaryMessenger) {
        
        // 解决 Failed to bind EAGLDrawable 错误
        // 如果frame是zeroed，则初始化一个宽高
        if (frame.width == 0 || frame.height == 0) {
            _frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        } else {
            _frame = frame
        }
        
        mapView = MAMapView(frame: _frame)
        // 自动调整宽高
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        channel = FlutterMethodChannel(name: "plugins.laoqiu.com/amap_view_\(viewId)", binaryMessenger: messenger)
        
        markerController = MarkerController(withChannel: channel, withMap: mapView)
        
        super.init()
        
        channel.setMethodCallHandler(onMethodCall)
        
        mapView.delegate = self
        
        // 处理参数
        if let args = args as? [String: Any] {
            Convert.interpretMapOptions(options: args["options"], delegate: self)
            updateInitialMarkers(options: args["markersToAdd"])
        }
    }
    
    func view() -> UIView {
        return mapView
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch(methodCall.method) {
        case "map#waitForMap":
            result(nil)
        case "map#update":
            if let args = methodCall.arguments as? [String: Any] {
                Convert.interpretMapOptions(options: args["options"], delegate: self)
            }
            result(nil)
        case "markers#update":
            if let args = methodCall.arguments as? [String: Any] {
                if let markersToAdd = (args["markersToAdd"] as? [Any]) {
                    markerController.addMarkers(markersToAdd: markersToAdd)
                }
                if let markersToChange = args["markersToChange"] as? [Any] {
                    markerController.changeMarkers(markersToChange: markersToChange)
                }
                if let markerIdsToRemove = args["markerIdsToRemove"] as? [Any] {
                    markerController.removeMarkers(markerIdsToRemove: markerIdsToRemove)
                }
            }
            result(nil)
        case "camera#update":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func updateInitialMarkers(options: Any?) {
        if let markers = options as? [Any] {
            markerController.addMarkers(markersToAdd: markers)
        }
    }
    
    // MAMapViewDelegate
    
    // 设置标注样式 会影响当前定位蓝点
//    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
//        if annotation.isKind(of: MAPointAnnotation.self) {
//            let pointReuseIndetifier = "pointReuseIndetifier"
//            var annotationView: MAAnnotationView? = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier)
//            if annotationView === nil {
//                annotationView = MAAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
//            }
//
//            // 配置参数
//            annotationView!.isDraggable = false
//
//            return annotationView
//        }
//        return nil
//    }
    
    // 地图将要移动时调用
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        print("mapWillMoveByUser ===>", mapView.centerCoordinate)
    }
    
    // 地图移动结束调用
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        let center = LatLng(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let position = CameraPosition(bearing: 0, tilt: 0, zoom: 0, target: center)
        let args: [String: Any] = ["position": Convert.toJson(position: position)]
        channel.invokeMethod("camera#onIdle", arguments: args)
    }
    
    // 地图定位失败调用
    func mapView(_ mapView: MAMapView!, didFailToLocateUserWithError error: Error!) {
        print("didFailToLocateUserWithError ===>", error)
    }
    
    // 单击地图返回经纬度
    func mapView(_ mapView: MAMapView!, didSingleTappedAt coordinate: CLLocationCoordinate2D) {
        let args: [String: Any] = ["position": Convert.toJson(location: coordinate)]
        channel.invokeMethod("map#onTap", arguments: args)
    }
    
    // 点击地图poi时返回信息
    func mapView(_ mapView: MAMapView!, didTouchPois pois: [Any]!) {
        print("didTouchPois ===>", pois)
    }

    // AMapOptionsSink
    func setCamera(camera: CameraPosition) {
        mapView.setCenter(CLLocationCoordinate2D(latitude: camera.target.latitude, longitude:  camera.target.longitude), animated: true)
        mapView.setZoomLevel(CGFloat(camera.zoom), animated: true)
    }
    
    func setMapType(mapType: Int) {
        switch mapType {
        case 2:
            mapView.mapType = MAMapType.satellite
        case 3:
            mapView.mapType = MAMapType.standardNight
        case 4:
            mapView.mapType = MAMapType.navi
        case 5:
            mapView.mapType = MAMapType.bus
        default:
            mapView.mapType = MAMapType.standard
        }
    }

    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool) {
        mapView.isRotateEnabled = rotateGesturesEnabled
    }
    
    func setScaleEnabled(scaleEnabled: Bool) {
        mapView.showsScale = scaleEnabled
    }
    
    func setCompassEnabled(compassEnabled: Bool) {
        mapView.showsCompass = compassEnabled
    }
    
    func setMyLocationEnabled(myLocationEnabled: Bool) {
        mapView.showsUserLocation = myLocationEnabled
        // 开启用户定位默认开启follow模式
        mapView.userTrackingMode = .follow
    }
    
    func setZoomEnabled(zoomEnabled: Bool) {
        mapView.isZoomEnabled = zoomEnabled
    }
    
    func setScrollEnabled(scrollEnabled: Bool) {
        mapView.isScrollEnabled = scrollEnabled
    }
    
}
