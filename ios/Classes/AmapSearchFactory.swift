//
//  AmapSearchFactory.swift
//  amap_search
//
//  Created by QiuLiang Wang on 2020/6/17.
//

import Foundation
import AMapFoundationKit
import AMapSearchKit


class AmapSearchFactory: NSObject, AMapSearchDelegate {
    private var messenger: FlutterBinaryMessenger
    private var search: AMapSearchAPI
    private var serchSink: FlutterResult!
    private var inputSink: FlutterResult!
    private var reGoecodeSink: FlutterResult!
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        search = AMapSearchAPI()
        super.init()
        
        search.delegate = self
    }
    
    func register() {
        let channel = FlutterMethodChannel(name: "plugins.muka.com/amap_search", binaryMessenger:messenger)
        channel.setMethodCallHandler(onMethodCall)
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch methodCall.method {
        case "poiKeywordsSearch":
            if let args = methodCall.arguments as? [String: Any] {
                let latitude = args["latitude"] as? CGFloat
                let longitude = args["longitude"] as? CGFloat
                if let keywords = args["keywords"] as? String {
                    let request = AMapPOIKeywordsSearchRequest()
                    request.keywords = keywords
                    request.requireExtension = true
                    if let city = args["city"] as? String {
                        request.city = city
                        request.cityLimit = true
                    }
                    if latitude != nil && longitude != nil {
                        request.location = AMapGeoPoint.location(withLatitude: latitude!, longitude: longitude!)
                    }
                    request.requireSubPOIs = true
                    serchSink = result
                    search.aMapPOIKeywordsSearch(request)
                }
            }
        case "inputTipsSearch":
            if let args = methodCall.arguments as? [String: Any] {
                let location = args["location"] as? String
                if let keywords = args["keywords"] as? String {
                    let request = AMapInputTipsSearchRequest()
                    request.keywords = keywords
                    if let city = args["city"] as? String {
                        request.city = city
                        request.cityLimit = true
                    }
                    if location != nil {
                        request.location = location
                    }
                    inputSink = result
                    search.aMapInputTipsSearch(request)
                }
            }
        case "reGeocodeSearch":
            if let args = methodCall.arguments as? [String: Any] {
                let latitude = args["latitude"] as? CGFloat
                let longitude = args["longitude"] as? CGFloat
                let request = AMapReGeocodeSearchRequest()
                request.location = AMapGeoPoint.location(withLatitude: latitude!, longitude: longitude!)
                request.requireExtension = true
                reGoecodeSink = result
                search.aMapReGoecodeSearch(request)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func onPOISearchDone(_ request: AMapPOISearchBaseRequest!, response: AMapPOISearchResponse!) {
        var pois = [Dictionary<String, Any>]()
        
        if response.count == 0 {
            return serchSink(pois)
        }
        for v in response.pois {
            let poi: Dictionary<String, Any> = ["adcode":v.adcode as Any, "address": v.address as Any, "businessArea": v.businessArea as Any, "city":v.city as Any, "citycode":v.citycode as Any,"direction":v.direction as Any,"distance":v.distance,"district": v.district as Any,"email":v.email as Any,"gridcode":v.gridcode as Any,"hasIndoorMap":v.hasIndoorMap,"name":v.name as Any,"parkingType":v.parkingType as Any,"pcode":v.pcode as Any,"postcode":v.postcode as Any,"province":v.province as Any,"shopID":v.shopID as Any,"tel":v.tel as Any,"type":v.type as Any,"typecode":v.typecode as Any,"uid":v.uid as Any,"website":v.website as Any, "latitude": v.location.latitude, "longitude":v.location.longitude]
            pois.append(poi)
        }
        serchSink(pois)
    }
    
    func onInputTipsSearchDone(_ request: AMapInputTipsSearchRequest!, response: AMapInputTipsSearchResponse!) {
        var pois = [Dictionary<String, Any>]()
        
        if response.count == 0 {
            return inputSink(pois)
        }
        for v in response.tips {
            let poi: Dictionary<String, Any> = ["adcode":v.adcode as Any, "address": v.address as Any, "district": v.district as Any,"name":v.name as Any,"typecode":v.typecode as Any,"uid":v.uid as Any, "latitude": v.location.latitude, "longitude":v.location.longitude]
            pois.append(poi)
        }
        inputSink(pois)
    }
    
    func onReGeocodeSearchDone(_ request: AMapReGeocodeSearchRequest!, response: AMapReGeocodeSearchResponse!) {
     
        if response.regeocode == nil {
            return reGoecodeSink(nil)
        }
        
        let gecode: Dictionary<String, Any> = ["adcode":response.regeocode.addressComponent.adcode, "building":response.regeocode.addressComponent.building,"city":response.regeocode.addressComponent.city, "citycode":response.regeocode.addressComponent.citycode, "country":response.regeocode.addressComponent.country,"district":response.regeocode.addressComponent.district,"province":response.regeocode.addressComponent.province,"streetNumber":response.regeocode.addressComponent.streetNumber as Any,"township":response.regeocode.addressComponent.township]
        reGoecodeSink(gecode)
    }
    
}
