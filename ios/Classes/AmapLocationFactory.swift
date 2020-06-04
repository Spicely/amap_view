//
//  AmapLocationFactory.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2019/4/25.
//

import Foundation
import AMapFoundationKit
import AMapLocationKit


class AmapLocationFactory: NSObject, AMapLocationManagerDelegate, FlutterStreamHandler {
    private var messenger: FlutterBinaryMessenger
    private var locationManager: AMapLocationManager
    private var fetchLocationManager: AMapLocationManager
    private var eventSink: FlutterEventSink?
    private var fetchResult: FlutterResult?
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        locationManager = AMapLocationManager()
        fetchLocationManager = AMapLocationManager()
        super.init()
        
        locationManager.distanceFilter = 200
        locationManager.delegate = self
        locationManager.allowsBackgroundLocationUpdates = true
        
        fetchLocationManager.distanceFilter = 200
        fetchLocationManager.delegate = self
    }
    
    func register() {
        let channel = FlutterMethodChannel(name: "plugins.laoqiu.com/amap_view_location", binaryMessenger:messenger)
        channel.setMethodCallHandler(onMethodCall)
        
        let event = FlutterEventChannel(name: "plugins.laoqiu.com/amap_view_location_event", binaryMessenger: messenger)
        event.setStreamHandler(self)
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "location#fetchLocation":
            fetchLocationManager.locatingWithReGeocode = true
            fetchResult = result
            fetchLocationManager.startUpdatingLocation()
        case "location#convert":
            if let args = methodCall.arguments as? [String: Any] {
                let coordType = getCoordType(t: args["coordType"] as? Int)
                let coord = AMapCoordinateConvert(
                    CLLocationCoordinate2D(latitude: (args["latitude"] as? Double)!, longitude: (args["longitude"] as? Double)!), coordType)
                let coordMap: Dictionary<String, Double> = ["latitude": coord.latitude, "longitude": coord.longitude]
                result(coordMap)
            } else {
                result(nil)
            }
        case "location#start":
            locationManager.locatingWithReGeocode = true
            locationManager.startUpdatingLocation()
            result(nil)
        case "location#stop":
            locationManager.stopUpdatingLocation()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        eventSink = events
        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didUpdate location: CLLocation!, reGeocode: AMapLocationReGeocode!) {
        if (location != nil) {
            var dataMap: Dictionary<String, Any> = ["speed": location.speed ,"altitude": location.altitude, "latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude, "accuracy": location.horizontalAccuracy]
            if (reGeocode != nil) {
                dataMap["address"] = reGeocode.formattedAddress
                dataMap["country"] = reGeocode.country
                dataMap["city"] = reGeocode.city
                dataMap["street"] = reGeocode.street
                dataMap["district"] = reGeocode.district
            }
            fetchResult?(dataMap)
            fetchResult = nil
            eventSink?(dataMap)
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func getCoordType(t: Int?) -> AMapCoordinateType {
        var coordType: AMapCoordinateType
        switch t {
        case 1:
            coordType = AMapCoordinateType.mapBar
        case 2:
            coordType = AMapCoordinateType.mapABC
        case 3:
            coordType = AMapCoordinateType.soSoMap
        case 4:
            coordType = AMapCoordinateType.aliYun
        case 5:
            coordType = AMapCoordinateType.google
        case 6:
            coordType = AMapCoordinateType.GPS
        default:
            coordType = AMapCoordinateType.baidu
        }
        return coordType
    }
    
}
