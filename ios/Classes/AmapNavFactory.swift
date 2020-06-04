//
//  AmapNavFactory.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2019/9/20.
//

import Foundation
import AMapNaviKit
import UIKit

class AmapNavFactory: NSObject, AMapNaviCompositeManagerDelegate {
    private var messenger: FlutterBinaryMessenger
    private var compositeManager: AMapNaviCompositeManager!
    private var navigationController: UIViewController!
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        
        super.init()
    }
    
    func register() {
        let channel = FlutterMethodChannel(name: "plugins.laoqiu.com/amap_view_navi", binaryMessenger:messenger)
        channel.setMethodCallHandler(onMethodCall)
        
        self.navigationController = UIApplication.shared.delegate?.window?!.rootViewController
    }

    func onMethodCall(methodCall: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (methodCall.method) {
        case "navi#showRoute":
             if let args = methodCall.arguments as? [String: Any] {
    
                if let naviType = args["naviType"] as? Int {
                    if naviType == 0 {
                        self.compositeManager = AMapNaviCompositeManager.init()
                        self.compositeManager.delegate = self
                        let config = AMapNaviCompositeUserConfig.init()
                        if let start = args["start"] as? [String: Any] {
                            if let point = start["target"] as? [String: Double] {
                                config.setRoutePlanPOIType(
                                    AMapNaviRoutePlanPOIType.start,
                                    location: AMapNaviPoint.location(withLatitude: CGFloat(point["latitude"]!), longitude: CGFloat(point["longitude"]!)),
                                    name: start["name"] as? String,
                                    poiId: nil)
                            }
                        }
                        if let end = args["end"] as? [String: Any] {
                            if let point = end["target"] as? [String: Double] {
                                config.setRoutePlanPOIType(
                                    AMapNaviRoutePlanPOIType.end,
                                    location: AMapNaviPoint.location(withLatitude: CGFloat(point["latitude"]!), longitude: CGFloat(point["longitude"]!)),
                                    name: end["name"] as? String,
                                    poiId: nil)
                            }
                        }
                        if let wayList = args["wayList"] as? [[String: Double]] {
                            var i = 0;
                            for w in wayList {
                                config.setRoutePlanPOIType(
                                    AMapNaviRoutePlanPOIType.way,
                                    location: AMapNaviPoint.location(withLatitude: CGFloat(w["latitude"]!), longitude: CGFloat(w["longitude"]!)),
                                    name: String(i),
                                    poiId: nil)
                                i += 1
                            }
                        }
                        self.compositeManager.presentRoutePlanViewController(withOptions: config)
                    } else {
                        
                        let amapNaviViewController = AmapNaviViewController()
                        if let start = args["start"] as? [String: Any] {
                            if let point = start["target"] as? [String: Double] {
                                amapNaviViewController.startPoint = AMapNaviPoint.location(withLatitude: CGFloat(point["latitude"]!), longitude: CGFloat(point["longitude"]!))
                            }
                        }
                        if let end = args["end"] as? [String: Any] {
                            if let point = end["target"] as? [String: Double] {
                               amapNaviViewController.endPoint = AMapNaviPoint.location(withLatitude: CGFloat(point["latitude"]!), longitude: CGFloat(point["longitude"]!))
                            }
                        }
                        amapNaviViewController.naviType = naviType
                        amapNaviViewController.modalPresentationStyle = .fullScreen
                        navigationController?.present(amapNaviViewController, animated: true)
                    }
                }
             }
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }
}
	
