//
//  AmapMarkerController.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2019/5/5.
//

import AMapNaviKit


class MarkerController: NSObject {
    
    var mapView: MAMapView
    var channel: FlutterMethodChannel
    
    // markerId(dart端)与marker的映射关系
    var markerIdToMarker = [String: MAPointAnnotation]()
    
    // markerId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
    var markerIdToOptions = [String: Any]()
    
    init(withChannel channel: FlutterMethodChannel, withMap mapView: MAMapView) {
        self.channel = channel
        self.mapView = mapView
        super.init()
    }
    
    func addMarker(options: Any) {
        if let opts = options as? [String: Any] {
            let point = MAPointAnnotation()
            if let position = opts["position"] as? [String: Double] {
                point.coordinate = CLLocationCoordinate2D(latitude: position["latitude"]!, longitude: position["longitude"]!)
            }
            point.title = "test"
            point.subtitle = "test subtitle"
            let markerId = opts["markerId"] as! String
            mapView.addAnnotation(point)
            
            // 保存状态
            markerIdToMarker[markerId] = point
            markerIdToOptions[markerId] = options
            // markerIdToDartMarkerId[]
        }
    }
    
    func changeMarker(options: Any) {
        if let opts = options as? [String: Any] {
            let markerId = opts["markerId"] as! String
            if let point = markerIdToMarker[markerId] {
                if let position = opts["position"] as? [String: Double] {
                    point.coordinate = CLLocationCoordinate2D(latitude: position["latitude"]!, longitude: position["longitude"]!)
                }
            }
        }
    }
    
    func addMarkers(markersToAdd: [Any]) {
        for o in markersToAdd {
            addMarker(options: o)
        }
    }
    
    func changeMarkers(markersToChange: [Any]) {
        for o in markersToChange {
            changeMarker(options: o)
        }
    }
    
    func removeMarkers(markerIdsToRemove: [Any]) {
        print("markerIdsToRemove ===>", markerIdsToRemove)
    }
}
