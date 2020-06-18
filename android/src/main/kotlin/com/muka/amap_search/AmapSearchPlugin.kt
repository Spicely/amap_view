package com.muka.amap_search

import androidx.annotation.NonNull
import com.amap.api.location.CoordinateConverter
import com.amap.api.maps.AMapUtils
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.geocoder.GeocodeResult
import com.amap.api.services.geocoder.GeocodeSearch
import com.amap.api.services.geocoder.RegeocodeQuery
import com.amap.api.services.geocoder.RegeocodeResult
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** AmapSearchPlugin */
public class AmapSearchPlugin : FlutterPlugin, MethodCallHandler, GeocodeSearch.OnGeocodeSearchListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var utilsChannel: MethodChannel
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var  regecodeSkin :Result

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_search")
        channel.setMethodCallHandler(this)
        utilsChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_utils")
        utilsChannel.setMethodCallHandler(this);
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "amap_search")
            channel.setMethodCallHandler(AmapSearchPlugin())
            val utilsChannel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_utils")
            utilsChannel.setMethodCallHandler(AmapSearchPlugin());
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
            "reGeocodeSearch" -> {
                var latitude = call.argument<Double>("latitude")
                var longitude = call.argument<Double>("longitude")
                if (latitude != null && longitude != null) {
                    var geocoderSearch = GeocodeSearch(this.pluginBinding.applicationContext)
                    geocoderSearch.setOnGeocodeSearchListener(this)
                    var query = RegeocodeQuery(LatLonPoint(latitude, longitude), 200F,GeocodeSearch.AMAP);
                    geocoderSearch.getFromLocationAsyn(query)
                    this.regecodeSkin = result
                }

//                result.success(distance)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        utilsChannel.setMethodCallHandler(null)
    }

    override fun onRegeocodeSearched(result: RegeocodeResult?, rCode: Int) {
        //解析result获取地址描述信息
        if (rCode != 1000) {
            this.regecodeSkin.success(null)
        }
        
    }

    override fun onGeocodeSearched(p0: GeocodeResult?, p1: Int) {

    }
}
