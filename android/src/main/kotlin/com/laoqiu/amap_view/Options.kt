package com.laoqiu.amap_view

import android.graphics.Color
import android.util.Log
import com.amap.api.maps.AMap
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.model.*


class UnifiedMapOptions(
        private val mapType: Int = AMap.MAP_TYPE_NORMAL,
        private val myLocationStyle: Int = MyLocationStyle.LOCATION_TYPE_SHOW,
        private val camera: CameraPosition? = null,
        private val rotateGesturesEnabled: Boolean = true,
        private val scrollGesturesEnabled: Boolean = true,
        private val scaleControlsEnabled: Boolean = false,
        private val compassEnabled: Boolean = false,
        private val tiltGesturesEnabled: Boolean = true,
        private val zoomControlsEnabled: Boolean = false,
        private val zoomGesturesEnabled: Boolean = true,
        private val myLocationEnabled: Boolean = false,
        private val setMyLocationButtonEnabled: Boolean = false) {

    fun getMyLocationEnable(): Boolean {
        return myLocationEnabled
    }

    fun getMyLocationStyle(): Int {
        return myLocationStyle
    }

    fun getMyLocationButtonEnabled(): Boolean {
        return setMyLocationButtonEnabled
    }

    fun toAMapOptions(): AMapOptions {
        return AMapOptions()
                .mapType(mapType)
                .camera(camera)
                .zoomControlsEnabled(zoomControlsEnabled)
                .zoomGesturesEnabled(zoomGesturesEnabled)
                .rotateGesturesEnabled(rotateGesturesEnabled)
                .tiltGesturesEnabled(tiltGesturesEnabled)
                .scaleControlsEnabled(scaleControlsEnabled)
                .scrollGesturesEnabled(scrollGesturesEnabled)
                .compassEnabled(compassEnabled)
    }

}

class UnifiedMarkerOptions(
        val markerId: String,
        val icon: List<Any>,
        val anchor: List<Float>,
        val position: LatLng? = null,
        val alpha: Float = 1.0f,
        val visible: Boolean = true,
        val flat: Boolean = false,
        val draggable: Boolean = true,
        var infoWindowEnable: Boolean = true,
        val zIndex: Float = 1.0f,
        val rotation: Float = 0.0f,
        val infoWindow: Map<String, Any>) {

    fun toMarkerOptions(): MarkerOptions {
        var opts = MarkerOptions()
                .alpha(alpha)
                .setFlat(flat)
                .anchor(anchor[0], anchor[1])
                .position(position)
                .visible(visible)
                .zIndex(zIndex)
                .rotateAngle(rotation)
                .draggable(draggable)
                .infoWindowEnable(infoWindowEnable)
        if (infoWindow["title"] != null) {
            opts.title(infoWindow["title"] as String)
        }
        if (infoWindow["snippet"] != null) {
            opts.snippet(infoWindow["snippet"] as String)
        }
        if (infoWindow["anchor"] != null) {
            var anchor = infoWindow["anchor"] as List<Float>
            opts.setInfoWindowOffset(anchor[0].toInt(), anchor[1].toInt())
        }

        return opts
    }

}

class UnifiedPolylineOptions(
        var polylineId: String,
        val visible: Boolean = true,
        var points: List<LatLng>,
        var color: Number,
        var width: Float = 10.0f,
        val zIndex: Float = 1.0f) {

    fun toPolylineOptions(): PolylineOptions {
        var opts = PolylineOptions()
                .visible(visible)
                .addAll(points)
                .color(color.toInt())
                .width(width)
                .zIndex(zIndex)
        return opts
    }
}
