//
//  Convert.swift
//  amap_view
//
//  Created by QiuLiang Wang on 2019/4/23.
//

import AMapNaviKit

let jsonEncoder = JSONEncoder()
let jsonDecoder = JSONDecoder()

class Convert {
    class func interpretMapOptions(options: Any?, delegate: AmapOptionsSink) {
        if let opts = options as? [String: Any] {
            if let camera = opts["camera"] as? [String: Any] {
                delegate.setCamera(camera: toCamera(opts: camera))
            }
            if let compassEnabled = opts["compassEnabled"] as? Bool {
                delegate.setCompassEnabled(compassEnabled: compassEnabled)
            }
            if let mapType = opts["mapType"] as? Int {
                delegate.setMapType(mapType: mapType)
            }
            if let myLocationEnabled = opts["myLocationEnabled"] as? Bool {
                delegate.setMyLocationEnabled(myLocationEnabled: myLocationEnabled)
            }
            if let scaleControlsEnabled = opts["scaleControlsEnabled"] as? Bool {
                delegate.setScaleEnabled(scaleEnabled: scaleControlsEnabled)
            }
            if let zoomControlsEnabled = opts["zoomControlsEnabled"] as? Bool {
                delegate.setZoomEnabled(zoomEnabled: zoomControlsEnabled)
            }
            if let scrollGesturesEnabled = opts["scrollGesturesEnabled"] as? Bool {
                delegate.setScrollEnabled(scrollEnabled: scrollGesturesEnabled)
            }
        }
    }
    
    class func toCamera(opts: [String: Any]) -> CameraPosition {
        let bearing = opts["bearing"] as! Double
        let tilt = opts["tilt"] as! Double
        let zoom = opts["zoom"] as! Double
        let target = toLatLng(options: opts["target"]!)
        return CameraPosition(bearing: bearing, tilt: tilt, zoom: zoom, target: target)
    }
    
    class func toLatLng(options: Any) -> LatLng {
        let opts = options as! [String: Any]
        let latitude = opts["latitude"] as! Double
        let longitude = opts["longitude"] as! Double
        return LatLng(latitude: latitude, longitude: longitude)
    }
    
    class func toJson(latLng: LatLng) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["latitude"] = latLng.latitude
        data["longitude"] = latLng.longitude
        return data
    }
    
    class func toJson(position: CameraPosition) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["target"] = toJson(latLng: position.target)
        data["bearing"] = position.bearing
        data["tilt"] = position.tilt
        data["zoom"] = position.zoom
        return data
    }
    
    class func toJson(location: CLLocationCoordinate2D) -> Dictionary<String, Any> {
        var data = [String: Any]()
        data["latitude"] = location.latitude
        data["longitude"] = location.longitude
        return data
    }
}

