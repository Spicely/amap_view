package com.muka.amap_view

import com.amap.api.maps.AMap
import com.amap.api.maps.model.Polyline
import io.flutter.plugin.common.MethodChannel


/// PolylineController Polyline的操作类
class PolylineController(private val methodChannel: MethodChannel, private val map: AMap) {

    // polylineId(dart端)与polyline的映射关系
    private val polylineIdToPolyline = HashMap<String, Polyline>();

    // polylineId(dart端)与传入参数的映射关系，用于区别哪些参数发生变化
    private val polylineIdToOptions = HashMap<String, UnifiedPolylineOptions>();

    // Polyline.Id与dart端polylineId的映射关系
    private val polylineIdToDartPolylineId = HashMap<String, String>();

    fun addPolyline(opts: Any) {
        var options = Convert.toUnifiedPolylineOptions(opts)
        var polylineId = options.polylineId
        var polyline = map.addPolyline(options.toPolylineOptions())
        polylineIdToPolyline[polylineId] = polyline
        polylineIdToOptions[polylineId] = options
        polylineIdToDartPolylineId[polyline.id] = polylineId
    }

    fun changePolyline(opts: Any) {
        var options = Convert.toUnifiedPolylineOptions(opts)
        var polylineId = options.polylineId
        var polyline = polylineIdToPolyline[polylineId]
        var oldOptions = polylineIdToOptions[polylineId]
        if (polyline != null && oldOptions != null) {
            Convert.interpretPolylineOptions(polyline, options, oldOptions)
            polylineIdToOptions[polylineId] = options
        }
    }

    fun addPolylines(polylinesToAdd: List<Any>) {
        if (polylinesToAdd != null) {
            for (polylineToAdd in polylinesToAdd) {
                addPolyline(polylineToAdd)
            }
        }
    }

    fun changePolylines(polylinesToChange: List<Any>) {
        if (polylinesToChange != null) {
            for (polylineToChange in polylinesToChange) {
                changePolyline(polylineToChange)
            }
        }
    }

    fun removePolylines(polylineIdsToRemove: List<Any>) {
        if (polylineIdsToRemove != null) {
            for (polylineId in polylineIdsToRemove) {
                var polyline = polylineIdToPolyline[polylineId]
                if (polyline != null) {
                    // 删除当前polyline
                    polylineIdToPolyline.remove(polylineId)
                    polylineIdToOptions.remove(polylineId)
                    polylineIdToDartPolylineId.remove(polyline.id)
                    polyline.remove()
                }
            }
        }
    }

    fun onPolylineTap(id: String): Boolean {
        var polylineId = polylineIdToDartPolylineId[id]
        if (polylineId != null) {
            methodChannel.invokeMethod("polyline#onTap", Convert.polylineIdToJson(polylineId))
            return true
        }
        return false
    }

}