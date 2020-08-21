//
//  AmapViewController.swift
//  amap_view
//
//  Created by Spicely on 2020/7/6.
//

import Flutter
import AMapNaviKit

class AmapViewController: NSObject, FlutterPlatformView, MAMapViewDelegate, AmapOptionsSink {
    func setIndoorMap(indoorEnabled: Bool) {
        
    }
    
    
    private var _frame: CGRect
    private var mapView: MAMapView
    private var channel: FlutterMethodChannel
    private var markerController: MarkerController
    private var flutterRegister: FlutterPluginRegistrar
    
    init(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?, binaryMessenger register: FlutterPluginRegistrar) {
        flutterRegister = register
        
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
        channel = FlutterMethodChannel(name: "plugins.muka.com/amap_view_\(viewId)", binaryMessenger: register.messenger())
        
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
    
    // 绘制marker
    func mapView(_ mapView: MAMapView!, viewFor annotation: MAAnnotation!) -> MAAnnotationView! {
        if annotation.isKind(of: MAPointAnnotation.self) {
            let ops =  markerController.markerIdToOptions.first(where:{ (arr,val) -> Bool in
                if let v = val as? [String: Any] {
                    if let position = v["position"] as? [String: Double] {
                        if (position["latitude"] == annotation.coordinate.latitude && position["longitude"] == annotation.coordinate.longitude ){
                            return true
                        }
                        return false
                    }
                }
                return false
            })
            if(ops == nil) {
                return nil
            }
            let pointReuseIndetifier = "pointReuseIndetifier"
            var annotationView: MAPinAnnotationView?
            
            if let opts = ops?.value as? [String: Any] {
                if let icon = opts["icon"] as? [Any] {
                    switch icon[0] as! String {
                    case "fromAssetImageWithText":
                        annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                        annotationView!.canShowCallout = true
                        annotationView!.animatesDrop = true
                        annotationView!.isDraggable = true
                        annotationView!.image = UIImage(imageLiteralResourceName:  flutterRegister.lookupKey(forAsset: icon[1] as! String))
                        
                        if let labelText = icon[3] as? [String: Any] {
                            if let offset = labelText["offset"] as? [Any] {
                                let labelView = UILabel.init(frame: CGRect(x: offset[0] as! Int,y: offset[1] as! Int,width: annotationView!.image.cgImage?.width ?? 0,height: annotationView!.image.cgImage?.height ?? 0))
                                labelView.font = UIFont.systemFont(ofSize: labelText["size"] as! CGFloat)
                                if let color = labelText["color"] as? [Any] {
                                    labelView.textColor = UIColor(red: color[0] as! CGFloat / 255, green: color[1] as! CGFloat / 255, blue: color[2] as! CGFloat / 255, alpha: 1)
                                }
                                labelView.textAlignment = NSTextAlignment.center
                                labelView.text = labelText["text"] as? String
                                annotationView?.addSubview(labelView)
                            }
                            
                        }
                    default:
                        annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: pointReuseIndetifier) as! MAPinAnnotationView?
                        
                        if annotationView == nil {
                            annotationView = MAPinAnnotationView(annotation: annotation, reuseIdentifier: pointReuseIndetifier)
                        }
                        print("----------------")
                    }
                }
            } else {
                print("233333333333333333333333")
                annotationView!.canShowCallout = true
                annotationView!.animatesDrop = true
                annotationView!.isDraggable = true
            }
            // print(annotationView!.value(forKey: "markerId") as Any)
            //                annotationView!.rightCalloutAccessoryView = UIButton(type: UIButtonType.detailDisclosure)
            
            //                let idx = annotations.index(of: annotation as! MAPointAnnotation)
            //                annotationView!.pinColor = MAPinAnnotationColor(rawValue: idx!%3)!
            
            return annotationView!
        }
        
        return nil
    }
    
    // 地图将要移动时调用
    func mapView(_ mapView: MAMapView!, mapWillMoveByUser wasUserAction: Bool) {
        print("mapWillMoveByUser ===>", mapView.centerCoordinate)
    }
    
    // 地图移动结束调用
    func mapView(_ mapView: MAMapView!, mapDidMoveByUser wasUserAction: Bool) {
        let center = LatLng(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
        let position = CameraPosition(bearing: 0, tilt: Double(mapView.cameraDegree), zoom: Double(mapView.zoomLevel), target: center)
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
        mapView.setCameraDegree(CGFloat(camera.tilt), animated: true, duration: 0.5)
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
        if myLocationEnabled {
            mapView.userTrackingMode = .follow
        } else {
            mapView.userTrackingMode = .none
        }
    }
    
    func setZoomEnabled(zoomEnabled: Bool) {
        mapView.isZoomEnabled = zoomEnabled
    }
    
    func setScrollEnabled(scrollEnabled: Bool) {
        mapView.isScrollEnabled = scrollEnabled
    }
    
}
