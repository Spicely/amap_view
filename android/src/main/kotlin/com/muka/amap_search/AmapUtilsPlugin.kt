package com.muka.amap_search

import androidx.annotation.NonNull
import com.amap.api.maps.AMapUtils
import com.amap.api.location.CoordinateConverter

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AmapUtilsPlugin */
public class AmapUtilsPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_utils")
        channel.setMethodCallHandler(this);
    }

    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_utils")
            channel.setMethodCallHandler(AmapUtilsPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
