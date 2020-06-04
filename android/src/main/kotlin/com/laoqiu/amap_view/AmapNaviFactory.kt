package com.laoqiu.amap_view

import android.annotation.SuppressLint
import android.content.Intent
import android.os.Bundle
import android.util.Log
import com.amap.api.navi.AmapNaviPage
import com.amap.api.navi.AmapNaviParams
import com.amap.api.navi.AmapNaviType
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.PluginRegistry


class AmapNaviFactory(private val registrar: PluginRegistry.Registrar) :
        MethodChannel.MethodCallHandler  {
    init {

        // 通信控制器
        val methodChannel = MethodChannel(registrar.messenger(), "plugins.laoqiu.com/amap_view_navi")
        methodChannel.setMethodCallHandler(this)
    }

    @SuppressLint("WrongConstant")
    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "navi#showRoute" -> {
                val naviType = call.argument<Int>("naviType")
                var start = Convert.toPoi(call.argument("start"))
                var end = Convert.toPoi(call.argument("end"))
                // TODO: wayList参数未处理
                var wayList = null
                if (end != null) {
                   when(naviType) {
                       1 , 2 -> {
                           var intent = Intent(registrar.activity(), AmapNaviActivity::class.java).addFlags(268435456)
                           val bundle = Bundle()
//                           Log.e("调试信息", start.toString())
                           if (start != null) {
                               var latLng = start.coordinate
                               bundle.putDouble("startLat", latLng.latitude)
                               bundle.putDouble("startLng", latLng.longitude)
                           } else {
                               bundle.putDouble("startLat", 0.0)
                               bundle.putDouble("startLng", 0.0)
                           }
                           var endLatLng = end.coordinate
                           bundle.putDouble("endLat", endLatLng.latitude)
                           bundle.putDouble("endLng", endLatLng.longitude)
                           bundle.putInt("naviType", naviType)
                           intent.putExtras(bundle)
                           registrar.activity().startActivity(intent)
                       }
                       else -> {
                           AmapNaviPage.getInstance().showRouteActivity(
                                   registrar.activity(),
    //                               AmapNaviParams(start, wayList, end, when (naviType) {
    //                                   1 -> AmapNaviType.WALK
    //                                   2 -> AmapNaviType.RIDE
    //                                   else -> AmapNaviType.DRIVER
    //                               }),
                                   AmapNaviParams(start, wayList, end, AmapNaviType.DRIVER),
                                   null
                           )
                       }
                   }
                }
                result.success(null)
            }
            else -> result.notImplemented()
        }
    }

}