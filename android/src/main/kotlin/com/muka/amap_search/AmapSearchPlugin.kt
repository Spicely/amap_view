package com.muka.amap_search

import androidx.annotation.NonNull
import com.amap.api.location.CoordinateConverter
import com.amap.api.maps.AMapUtils
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.core.PoiItem
import com.amap.api.services.geocoder.GeocodeResult
import com.amap.api.services.geocoder.GeocodeSearch
import com.amap.api.services.geocoder.RegeocodeQuery
import com.amap.api.services.geocoder.RegeocodeResult
import com.amap.api.services.help.Inputtips
import com.amap.api.services.help.InputtipsQuery
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.PoiResult
import com.amap.api.services.poisearch.PoiSearch
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** AmapSearchPlugin */
public class AmapSearchPlugin : FlutterPlugin, MethodCallHandler, GeocodeSearch.OnGeocodeSearchListener, PoiSearch.OnPoiSearchListener, Inputtips.InputtipsListener {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var utilsChannel: MethodChannel
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private lateinit var regecodeSkin: Result
    private lateinit var poiKeywordsSkin: Result
    private lateinit var inputTipsSkin: Result

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_search")
        channel.setMethodCallHandler(this)
//        utilsChannel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_utils")
//        utilsChannel.setMethodCallHandler(this);
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
            val channel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_search")
            channel.setMethodCallHandler(AmapSearchPlugin())
//            val utilsChannel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_utils")
//            utilsChannel.setMethodCallHandler(AmapSearchPlugin());
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
                    var geocoderSearch = GeocodeSearch(pluginBinding.applicationContext)
                    geocoderSearch.setOnGeocodeSearchListener(this)
                    var query = RegeocodeQuery(LatLonPoint(latitude, longitude), 200F, GeocodeSearch.AMAP);
                    geocoderSearch.getFromLocationAsyn(query)
                    this.regecodeSkin = result
                }
            }
            "poiKeywordsSearch" -> {
                var keywords = call.argument<String>("keywords")
                var city = call.argument<String>("city")
                var pageSize = call.argument<Int>("pageSize") ?: 10
                var pageNum = call.argument<Int>("pageNum") ?: 1
                var latitude = call.argument<Double>("latitude")
                var longitude = call.argument<Double>("longitude")
                if (keywords != null) {
                    var query = PoiSearch.Query(keywords, "",  city)
                    if (city != null) {
                        query.cityLimit = true
                    }
                    if (latitude != null && longitude != null) {
                        query.location = LatLonPoint(latitude, longitude)
                    }
                    query.pageSize = pageSize;// 设置每页最多返回多少条poiitem
                    query.pageNum = pageNum;//设置查询页码
                    var poiSearch = PoiSearch(pluginBinding.applicationContext, query)
                    poiSearch.setOnPoiSearchListener(this)
                    poiSearch.searchPOIAsyn()
                    this.poiKeywordsSkin = result
                }
            }
            "inputTipsSearch" -> {
                var keywords = call.argument<String>("keywords")
                var city = call.argument<String>("city")
                var latitude = call.argument<Double>("latitude")
                var longitude = call.argument<Double>("longitude")
                if (keywords != null) {
                    var query = InputtipsQuery(keywords, city)
                    if (city != null) {
                        query.cityLimit = true
                    }
                    if (latitude != null && longitude != null) {
                        query.location = LatLonPoint(latitude, longitude)
                    }
                    val inputTips = Inputtips(this.pluginBinding.applicationContext, query)
                    inputTips.setInputtipsListener(this)
                    inputTips.requestInputtipsAsyn()
                    this.inputTipsSkin = result
                }
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
            return
        }
        if (result == null) {
            this.regecodeSkin.success(null)
        } else {
            this.regecodeSkin.success(Convert.toJson(result))
        }
    }

    override fun onPoiItemSearched(p0: PoiItem?, p1: Int) {

    }

    override fun onPoiSearched(result: PoiResult?, rCode: Int) {
        //解析result获取POI信息
        if (rCode != 1000) {
            this.poiKeywordsSkin.success(emptyArray<Any>())
        }
        if (result == null) {
            this.poiKeywordsSkin.success(emptyArray<Any>())
        } else {
            this.poiKeywordsSkin.success(Convert.toArr(result))
        }
    }

    override fun onGeocodeSearched(p0: GeocodeResult?, p1: Int) {

    }

    override fun onGetInputtips(result: MutableList<Tip>?, rCode: Int) {
        if (rCode != 1000) {
            this.inputTipsSkin.success(emptyArray<Any>())
        }
        if (result == null) {
            this.inputTipsSkin.success(emptyArray<Any>())
        } else {
            this.inputTipsSkin.success(Convert.toArr(result))
        }
    }
}
