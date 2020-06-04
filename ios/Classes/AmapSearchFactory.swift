//
//  AmapSearchFactory.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2019/9/20.
//

import Foundation
import AMapSearchKit

class AmapSearchFactory: NSObject, AMapSearchDelegate {
    private var messenger: FlutterBinaryMessenger
    private var search: AMapSearchAPI
    private var result: FlutterResult?
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        search = AMapSearchAPI()
        super.init()
        
        search.delegate = self
    }
    
    func register() {
        let channel = FlutterMethodChannel(name: "plugins.laoqiu.com/amap_view_search", binaryMessenger:messenger)
        channel.setMethodCallHandler(onMethodCall)
    }
    
    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (methodCall.method) {
        case "search#geocode":
            if let args = methodCall.arguments as? [String: Any] {
                let req = AMapGeocodeSearchRequest()
                req.address = args["address"] as? String
                req.city = args["city"] as? String
                search.aMapGeocodeSearch(req)
                self.result = result
            } else {
                result(nil)
            }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    func onGeocodeSearchDone(_ request: AMapGeocodeSearchRequest!, response: AMapGeocodeSearchResponse!) {
        if response.geocodes.count > 0 {
            let data: Dictionary<String, Any> = ["latitude": response.geocodes[0].location.latitude, "longitude": response.geocodes[0].location.longitude]
            result!(data)
        } else {
            result!(nil)
        }
    }
}
