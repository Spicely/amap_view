package com.laoqiu.amap_view

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
        when (call.method) {
            "utils#calculateLineDistance" -> {
                var start = Convert.toLatLng(call.argument("start"))
                var end = Convert.toLatLng(call.argument("end"))
                var distance = AMapUtils.calculateLineDistance(start, end)
                result.success(distance)
            }
            "utils#calculateArea" -> {
                var start = Convert.toLatLng(call.argument("start"))
                var end = Convert.toLatLng(call.argument("end"))
                var distance = AMapUtils.calculateArea(start, end)
                result.success(distance)
            }
            "utils#converter" -> {
                var sourceLatLng = Convert.toLatLng(call.argument("sourceLatLng"))
                val coordType = call.argument<Int>("coordType")
                val converter = CoordinateConverter(registrar.activity())
                when(coordType) {
                    0 -> converter.from(CoordinateConverter.CoordType.BAIDU)
                    1 -> converter.from(CoordinateConverter.CoordType.ALIYUN)
                    2 -> converter.from(CoordinateConverter.CoordType.GOOGLE)
                    3 -> converter.from(CoordinateConverter.CoordType.GPS)
                    4 -> converter.from(CoordinateConverter.CoordType.MAPABC)
                    5 -> converter.from(CoordinateConverter.CoordType.MAPBAR)
                    6 -> converter.from(CoordinateConverter.CoordType.SOSOMAP)
                }
                converter.coord(sourceLatLng)
                val desLatLng = converter.convert()
                result.success(Convert.toJson(desLatLng))
            }
            else -> result.notImplemented()
        }
    }

}