package com.muka.amap_view

import com.amap.api.maps.AMap
import com.amap.api.maps.model.Marker
import io.flutter.plugin.common.MethodChannel


/// MarkerController Markers的操作类
class MarkerController(private val methodChannel: MethodChannel, private val map: AMap) {

    // markerId(dart端)与marker的映射关系
    private val markerIdToMarker = HashMap<String, Marker>();

    // markerId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
    private val markerIdToOptions = HashMap<String, UnifiedMarkerOptions>();

    // Marker.Id与dart端markerId的映射关系
    private val markerIdToDartMarkerId = HashMap<String, String>();

    fun addMarker(opts: Any) {
        var options = Convert.toUnifiedMarkerOptions(opts)
        var markerId = options.markerId
        var marker = map.addMarker(options.toMarkerOptions())
        Convert.interpretMarkerOptions(marker, options, null)
        markerIdToMarker[markerId] = marker
        markerIdToOptions[markerId] = options
        markerIdToDartMarkerId[marker.id] = markerId
    }

    fun changeMarker(opts: Any) {
        var options = Convert.toUnifiedMarkerOptions(opts)
        var markerId = options.markerId
        var marker = markerIdToMarker[markerId]
        var oldOptions = markerIdToOptions[markerId]
        if (marker != null && oldOptions != null) {
            Convert.interpretMarkerOptions(marker, options, oldOptions)
            markerIdToOptions[markerId] = options
        }
    }

    fun addMarkers(markersToAdd: List<Any>) {
        if (markersToAdd != null) {
            for (markerToAdd in markersToAdd) {
                addMarker(markerToAdd)
            }
        }
    }

    fun changeMarkers(markersToChange: List<Any>) {
        if (markersToChange != null) {
            for (markerToChange in markersToChange) {
                changeMarker(markerToChange)
            }
        }
    }

    fun removeMarkers(markerIdsToRemove: List<Any>) {
        if (markerIdsToRemove != null) {
            for (markerId in markerIdsToRemove) {
                var marker = markerIdToMarker[markerId]
                if (marker != null) {
                    // 删除当前marker
                    markerIdToMarker.remove(markerId)
                    markerIdToOptions.remove(markerId)
                    markerIdToDartMarkerId.remove(marker.id)
                    marker.destroy()
                }
            }
        }
    }

    fun onInfoWindowTap(id: String) {
        var markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            methodChannel.invokeMethod("infoWindow#onTap", Convert.markerIdToJson(markerId))
        }
    }

    fun onMarkerTap(id: String): Boolean {
        var markerId = markerIdToDartMarkerId[id]
        if (markerId != null) {
            methodChannel.invokeMethod("marker#onTap", Convert.markerIdToJson(markerId))
            return true
        }
        return false
    }

}