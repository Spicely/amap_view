package com.muka.amap_navi

import android.annotation.SuppressLint
import android.app.Activity
import android.content.Intent
import android.os.Bundle
import androidx.annotation.NonNull;
import com.amap.api.navi.AmapNaviPage
import com.amap.api.navi.AmapNaviParams
import com.amap.api.navi.AmapNaviType

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar

/** AmapNaviPlugin */
public class AmapNaviPlugin : FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        pluginBinding = flutterPluginBinding
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_navi")
        channel.setMethodCallHandler(this);
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
            val channel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_navi")
            channel.setMethodCallHandler(AmapNaviPlugin())
        }
    }

    @SuppressLint("WrongConstant")
    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
            "navi#showRoute" -> {
                val naviType = call.argument<Int>("naviType")
                var start = Convert.toPoi(call.argument("start"))
                var end = Convert.toPoi(call.argument("end"))
                // TODO: wayList参数未处理
                var wayList: Nothing? = null
                if (end != null) {
                    when (naviType) {
                        1, 2 -> {
                            var intent = Intent(pluginBinding.applicationContext, AmapNaviActivity::class.java).addFlags(268435456)
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
                            pluginBinding.applicationContext.startActivity(intent)
                        }
                        else -> {
                            AmapNaviPage.getInstance().showRouteActivity(
                                    pluginBinding.applicationContext,
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

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
