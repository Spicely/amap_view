package com.muka.amap_search

import android.annotation.SuppressLint
import com.amap.api.maps.AMapUtils
import com.amap.api.maps.CoordinateConverter
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class AmapUtilsFactory(private val registrar: PluginRegistry.Registrar) :
        MethodChannel.MethodCallHandler  {
    init {

        // 通信控制器
        val methodChannel = MethodChannel(registrar.messenger(), "plugins.laoqiu.com/amap_view_utils")
        methodChannel.setMethodCallHandler(this)
    }

    @SuppressLint("WrongConstant")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        "convert" -> {
            var latlng = Convert.toDPoint(call.argument("latlng"))
            var coordType = call.argument<Int>("type") ?: 0
            if (latlng != null) {
                var point = CoordinateConverter(pluginBinding.applicationContext).from(when (coordType) {
                    1 -> CoordinateConverter.CoordType.BAIDU
                    2 -> CoordinateConverter.CoordType.GOOGLE
                    else -> CoordinateConverter.CoordType.GPS
                }).coord(latlng).convert()
                result.success(Convert.toJson(point))
            } else {
                result.success(null)
            }
        }
        "calculateLineDistance" -> {
            var start = Convert.toLatLng(call.argument("start"))
            var end = Convert.toLatLng(call.argument("end"))
            var distance = AMapUtils.calculateLineDistance(start, end)
            result.success(distance)
        }
        "calculateArea" -> {
            var start = Convert.toLatLng(call.argument("start"))
            var end = Convert.toLatLng(call.argument("end"))
            var distance = AMapUtils.calculateArea(start, end)
            result.success(distance)
        }
        else -> {
            result.notImplemented()
        }
    }

}