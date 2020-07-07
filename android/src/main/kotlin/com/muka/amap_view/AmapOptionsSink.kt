package com.muka.amap_view

interface AmapOptionsSink {
    // fun setCamera(camera: CameraPosition)
    fun setCompassEnabled(compassEnabled: Boolean)
    fun setMapType(mapType: Int)
    fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean)
    fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean)
    fun setScaleEnabled(scaleEnabled: Boolean)
    fun setZoomGesturesEnabled(zoomGesturesEnabled: Boolean)
    fun setZoomControlsEnabled(zoomControlsEnabled: Boolean)
    fun setMyLocationEnabled(myLocationEnabled: Boolean)
}