//
//  AmapLocationFactory.swift
//  amap_location
//
//  Created by QiuLiang Wang on 2020/6/5.
//

import Foundation
import AMapFoundationKit
import AMapLocationKit


class AmapLocationFactory: NSObject, AMapLocationManagerDelegate, FlutterStreamHandler {
    private var messenger: FlutterBinaryMessenger
    private var locationManager: AMapLocationManager
    private var fetchLocationManager: AMapLocationManager
    private var eventSink: FlutterEventSink?
    private var timer: Timer?
    private var interval: Int = 2000
    private var start: Bool = true
    private var mapLoca: Dictionary<String, Any>?
    private var fetchLoca: Dictionary<String, Any>?
    private var fetchSink: FlutterResult?
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        locationManager = AMapLocationManager()
        fetchLocationManager = AMapLocationManager()
        super.init()
        
        locationManager.distanceFilter = 200
        locationManager.delegate = self
        locationManager.locatingWithReGeocode = true
        
        fetchLocationManager.distanceFilter = 200
        fetchLocationManager.delegate = self
    }
    
    func register() {
        let channel = FlutterMethodChannel(name: "plugins.muka.com/amap_location", binaryMessenger:messenger)
        channel.setMethodCallHandler(onMethodCall)
        
        let event = FlutterEventChannel(name: "plugins.muka.com/amap_location_event", binaryMessenger: messenger)
        event.setStreamHandler(self)
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {	
        case "fetch":
            let args = methodCall.arguments as? [String: Any]
            var accuracy = args?["accuracy"] as? Int
            if (accuracy == nil) {
                accuracy = 0
            }
            // 定位精度
            switch accuracy {
                case 1:
                    fetchLocationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                case 2:
                    fetchLocationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                case 3:
                    fetchLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                case 4:
                    fetchLocationManager.desiredAccuracy = kCLLocationAccuracyBest
                default:
                    fetchLocationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            }
            
            fetchLocationManager.requestLocation(withReGeocode: true) { (location: CLLocation!,reGeocode: AMapLocationReGeocode!, error: Error!) in
                if (error != nil) {
                    return result(nil)
                }
                if (location != nil) {
                    var dataMap: Dictionary<String, Any> = ["speed": location.speed ,"altitude": location.altitude, "latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude, "accuracy": location.horizontalAccuracy]
                    if (reGeocode != nil) {
                        dataMap["address"] = reGeocode.formattedAddress
                        dataMap["country"] = reGeocode.country
                        dataMap["city"] = reGeocode.city
                        dataMap["street"] = reGeocode.street
                        dataMap["district"] = reGeocode.district
                    }
                    result(dataMap)
                }
            }
        case "start":
            if let args = methodCall.arguments as? [String: Any] {
                interval = args["time"] as? Int ?? 2000
                var accuracy = args["accuracy"] as? Int
                if (accuracy == nil) {
                    accuracy = 0
                }
                // 定位精度
                switch accuracy {
                    case 1:
                        locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
                    case 2:
                        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
                    case 3:
                        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                    case 4:
                        locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    default:
                        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
                }
                timer?.invalidate()
                start = true
                timer =  Timer.scheduledTimer(timeInterval:TimeInterval(interval / 1000), target: self, selector: #selector(sinkLocation(_:)), userInfo: nil, repeats: true)
                locationManager.stopUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
            result(nil)
        case "stop":
            locationManager.stopUpdatingLocation()
            timer?.invalidate()
            result(nil)
        case "enableBackground":
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            timer?.invalidate()
            start = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval / 1000), target: self, selector: #selector(sinkLocation(_:)), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            result(nil)
        case "disableBackground":
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = false
            timer?.invalidate()
            start = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval / 1000), target: self, selector: #selector(sinkLocation(_:)), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    @objc func sinkLocation(_ time:Timer) -> Void  {
        if (mapLoca != nil) {
            eventSink?(mapLoca)
        }
    }
    
    func aMapSearchRequest(_ request: Any!, didFailWithError error: Error!) {
        self.fetchSink?(nil)
    }
    
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events
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
            self.mapLoca = dataMap
            if (start) {
                self.eventSink?(dataMap)
                self.start = false
            }
           
        }
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, doRequireLocationAuth locationManager: CLLocationManager!) {
        locationManager.requestAlwaysAuthorization()
    }
    
    func amapLocationManager(_ manager: AMapLocationManager!, didFailWithError error: Error!) {
        self.fetchSink?(nil)
    }
    
}
