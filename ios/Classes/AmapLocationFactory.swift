//
//  AmapLocationFactory.swift
//  amap_location
//
//  Created by QiuLiang Wang on 2020/6/5.
//

import Foundation
import AMapFoundationKit
import AMapLocationKit
import AMapSearchKit


class AmapLocationFactory: NSObject, AMapLocationManagerDelegate, FlutterStreamHandler, AMapSearchDelegate {
    private var messenger: FlutterBinaryMessenger
    private var locationManager: AMapLocationManager
    private var fetchLocationManager: AMapLocationManager
    private var search: AMapSearchAPI
    private var eventSink: FlutterEventSink?
    private var timer: Timer?
    private var interval: Int?
    private var start: Bool = true
    private var mapLoca: Dictionary<String, Any>?
    private var fetchLoca: Dictionary<String, Any>?
    private var fetchSink: FlutterResult?
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        locationManager = AMapLocationManager()
        fetchLocationManager = AMapLocationManager()
        search = AMapSearchAPI()
        super.init()
        
        search.delegate = self
        
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
            let geocode = args?["geocode"] as? Bool
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
                    if (geocode == true) {
                        let request = AMapReGeocodeSearchRequest()
                        request.location = AMapGeoPoint.location(withLatitude: CGFloat(location.coordinate.latitude), longitude: CGFloat(location.coordinate.longitude))
                        request.requireExtension = true
                        self.search.aMapReGoecodeSearch(request)
                        self.fetchLoca = dataMap
                        self.fetchSink = result
                    } else {
                        result(dataMap)
                    }
                }
            }
        case "start":
            if let args = methodCall.arguments as? [String: Any] {
                interval = args["time"] as? Int
                if (interval == nil) {
                    interval = 200
                }
                timer?.invalidate()
                start = true
                timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval! / 1000), target: self, selector: #selector(sinkLocation), userInfo: nil, repeats: true)
                locationManager.stopUpdatingLocation()
                locationManager.startUpdatingLocation()
            }
            result(nil)
        case "top":
            locationManager.stopUpdatingLocation()
            timer?.invalidate()
            result(nil)
        case "enableBackground":
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = true
            timer?.invalidate()
            start = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval! / 1000), target: self, selector: #selector(sinkLocation), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            result(nil)
        case "disableBackground":
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = false
            timer?.invalidate()
            start = true
            timer = Timer.scheduledTimer(timeInterval: TimeInterval(interval! / 1000), target: self, selector: #selector(sinkLocation), userInfo: nil, repeats: true)
            locationManager.startUpdatingLocation()
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    @objc func sinkLocation() {
        if (mapLoca != nil) {
            eventSink?(mapLoca)
        }
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
     
        if response.regeocode == nil {
            self.fetchSink?(nil)
            return
        }
        if self.fetchLoca == nil {
            self.fetchSink?(nil)
            return
        }
        var pois = [Dictionary<String, Any>]()
        for v in response.regeocode.pois {
            let poi: Dictionary<String, Any> = ["adcode":v.adcode as Any, "address": v.address as Any, "businessArea": v.businessArea as Any, "city":v.city as Any, "citycode":v.citycode as Any,"direction":v.direction as Any,"distance":v.distance,"district": v.district as Any,"email":v.email as Any,"gridcode":v.gridcode as Any,"hasIndoorMap":v.hasIndoorMap,"name":v.name as Any,"parkingType":v.parkingType as Any,"pcode":v.pcode as Any,"postcode":v.postcode as Any,"province":v.province as Any,"shopID":v.shopID as Any,"tel":v.tel as Any,"type":v.type as Any,"typecode":v.typecode as Any,"uid":v.uid as Any,"website":v.website as Any, "latitude": v.location.latitude, "longitude":v.location.longitude]
            pois.append(poi)
        }
        self.fetchLoca?["geocode"] = ["adcode":response.regeocode.addressComponent.adcode as Any, "building":response.regeocode.addressComponent.building as Any,"city":response.regeocode.addressComponent.city as Any, "citycode":response.regeocode.addressComponent.citycode as Any,"formatAddress": response.regeocode.formattedAddress as Any, "country":response.regeocode.addressComponent.country as Any,"district":response.regeocode.addressComponent.district as Any,"province":response.regeocode.addressComponent.province as Any,"streetNumber":response.regeocode.addressComponent.streetNumber as Any,"township":response.regeocode.addressComponent.township as Any,"pois": pois]
        self.fetchSink?(self.fetchLoca)
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
