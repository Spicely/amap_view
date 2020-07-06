//
//  AmapOptionsSink.swift
//  amap_view
//
//  Created by Spicely on 2020/7/6.
//


protocol AmapOptionsSink {
    func setCamera(camera: CameraPosition)
    func setCompassEnabled(compassEnabled: Bool)
    func setMapType(mapType: Int)
    func setRotateGesturesEnabled(rotateGesturesEnabled: Bool)
    func setMyLocationEnabled(myLocationEnabled: Bool)
    func setScaleEnabled(scaleEnabled: Bool)
    func setScrollEnabled(scrollEnabled: Bool)
    func setZoomEnabled(zoomEnabled: Bool)
    func setIndoorMap(indoorEnabled: Bool)
}

