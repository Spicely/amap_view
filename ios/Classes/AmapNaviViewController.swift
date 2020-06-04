//
//  AmapNaviViewController.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2020/5/13.
//
import UIKit
import AMapNaviKit

protocol DriveNaviViewControllerDelegate: NSObjectProtocol {
    func driveNaviViewCloseButtonClicked()
}

class AmapNaviViewController: UIViewController, MAMapViewDelegate, AMapNaviRideManagerDelegate, AMapNaviRideViewDelegate, AMapNaviWalkViewDelegate, AMapNaviWalkManagerDelegate {
    
    var mapView: MAMapView!
    
    var rideView: AMapNaviRideView!
    var rideManager: AMapNaviRideManager!
    
    var walkView: AMapNaviWalkView!
    var walkManager: AMapNaviWalkManager!
    
    var startPoint: AMapNaviPoint!
    var endPoint: AMapNaviPoint!
    var naviType: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSLog("初始化地图")
        initMapView()
        if (naviType == 1) {
            // 步行
            initWalkView()
            initWalkManager()
            if (startPoint ==  nil) {
                walkManager.calculateWalkRoute(withEnd: [endPoint])
            } else {
                walkManager.calculateWalkRoute(withStart: [startPoint], end: [endPoint])
            }
        } else {
            // 骑行
            initRideView()
            initRideManager()
            if (startPoint ==  nil) {
                rideManager.calculateRideRoute(withEnd: endPoint)
            } else {
                rideManager.calculateRideRoute(withStart: startPoint, end: endPoint)
            }
        }
    }
    
    func initMapView() {
       mapView = MAMapView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height))
       mapView.delegate = self
       view.addSubview(mapView)
    }
    
    func initRideView() {
        rideView = AMapNaviRideView(frame: view.bounds)
        rideView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        rideView.delegate = self
        view.addSubview(rideView)
     }
    
    func initWalkView() {
       walkView = AMapNaviWalkView(frame: view.bounds)
       walkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
       walkView.delegate = self
       view.addSubview(walkView)
    }
    
    func initWalkManager() {
        walkManager = AMapNaviWalkManager.sharedInstance()
        walkManager.allowsBackgroundLocationUpdates = true
        walkManager.pausesLocationUpdatesAutomatically = false
        walkManager.delegate = self
        walkManager.addDataRepresentative(walkView)
    }
    
    func initRideManager() {
        rideManager = AMapNaviRideManager.sharedInstance()
        rideManager.allowsBackgroundLocationUpdates = true
        rideManager.pausesLocationUpdatesAutomatically = false
        rideManager.delegate = self
        rideManager.addDataRepresentative(rideView)
    }
    
    
    func rideManager(onCalculateRouteSuccess rideManager: AMapNaviRideManager) {
//        NSLog("CalculateRouteSuccess")
       
        //算路成功后开始GPS导航
        AMapNaviRideManager.sharedInstance().startGPSNavi()
    }
    
    func rideManager(_ rideManager: AMapNaviRideManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        SpeechSynthesizer.Shared.speak(soundString)
    }
    
    
    func walkManager(onCalculateRouteSuccess walkManager: AMapNaviWalkManager) {
        //算路成功后开始GPS导航
        AMapNaviWalkManager.sharedInstance().startGPSNavi()
    }
    
    func walkManager(_ walkManager: AMapNaviWalkManager, playNaviSound soundString: String, soundStringType: AMapNaviSoundType) {
        SpeechSynthesizer.Shared.speak(soundString)
    }
   
    func rideViewCloseButtonClicked(_ rideView: AMapNaviRideView) {
//        NSLog("尝试返回flutter 页面")
        self.dismiss(animated: true, completion: nil)
    }
    
    func walkViewCloseButtonClicked(_ walkView: AMapNaviWalkView) {
//        NSLog("尝试返回flutter 页面")
        self.dismiss(animated: true, completion: nil)
    }
    
    deinit {
        SpeechSynthesizer.Shared.stopSpeak()
        if (naviType == 1) {
            AMapNaviWalkManager.sharedInstance().stopNavi()
            AMapNaviWalkManager.sharedInstance().removeDataRepresentative(walkView)
            AMapNaviWalkManager.sharedInstance().delegate = nil
            let success = AMapNaviWalkManager.destroyInstance()
//            NSLog("单例是否销毁成功 : \(success)")
        } else {
            AMapNaviRideManager.sharedInstance().stopNavi()
            AMapNaviRideManager.sharedInstance().removeDataRepresentative(rideView)
            AMapNaviRideManager.sharedInstance().delegate = nil
                
            let success = AMapNaviRideManager.destroyInstance()
//            NSLog("单例是否销毁成功 : \(success)")
        }
    }
}
