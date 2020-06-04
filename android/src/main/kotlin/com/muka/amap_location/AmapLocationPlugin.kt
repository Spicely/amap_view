package com.muka.amap_location

import android.R
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.graphics.Color
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.content.ContextCompat.getSystemService
import com.amap.api.location.AMapLocationClient
import com.amap.api.location.AMapLocationClientOption
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** AmapLocationPlugin */
public class AmapLocationPlugin: FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

  private lateinit var channel : MethodChannel
  private lateinit var eventChannel : EventChannel
  private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
  private var eventSink: EventChannel.EventSink? = null
  private lateinit var watchClient: AMapLocationClient
  private val NOTIFICATION_CHANNEL_NAME = "BackgroundLocation"
  private var notificationManager: NotificationManager? = null
  var isCreateChannel = false

  @RequiresApi(Build.VERSION_CODES.O)
  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    pluginBinding = flutterPluginBinding
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_location")
    channel.setMethodCallHandler(this);
    eventChannel = EventChannel(flutterPluginBinding.binaryMessenger, "plugins.muka.com/amap_location_event")
    eventChannel.setStreamHandler(this);
    watchClient = AMapLocationClient(flutterPluginBinding.applicationContext)
    watchClient.setLocationListener {
      if (it != null) {
        if (it.errorCode == 0) {
          eventSink?.success(Convert.toJson(it))
        } else {
          eventSink?.error("AmapError", "onLocationChanged Error: ${it.errorInfo}", it.errorInfo)
        }
      }
    }
  }

  companion object {
    @JvmStatic
    fun registerWith(registrar: Registrar) {
      val channel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_location")
      channel.setMethodCallHandler(AmapLocationPlugin())
      val eventChannel = EventChannel(registrar.messenger(), "plugins.muka.com/amap_location_event")
      eventChannel.setStreamHandler(AmapLocationPlugin());
    }
  }

  @RequiresApi(Build.VERSION_CODES.O)
  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "fetch" -> {
        var mode: Any? = call.argument("mode")
        var locationClient = AMapLocationClient(pluginBinding.applicationContext)
        var locationOption = AMapLocationClientOption()
        locationOption.locationMode = when(mode) {
          1 -> AMapLocationClientOption.AMapLocationMode.Battery_Saving
          2 -> AMapLocationClientOption.AMapLocationMode.Device_Sensors
          else -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        }
        locationClient.setLocationOption(locationOption)
        locationClient.setLocationListener {
          if (it != null) {
            if (it.errorCode == 0) {
              result.success(Convert.toJson(it))
            } else {
              result.error("AmapError", "onLocationChanged Error: ${it.errorInfo}", it.errorInfo)
            }
          }
        }
        locationClient.startLocation()
      }
      "start" -> {
        var mode: Any? = call.argument("mode")
        var time: Int = call.argument<Int>("time") ?: 2000
        var background: Boolean? = call.argument("background")
        var locationOption = AMapLocationClientOption()
        locationOption.locationMode = when(mode) {
          1 -> AMapLocationClientOption.AMapLocationMode.Battery_Saving
          2 -> AMapLocationClientOption.AMapLocationMode.Device_Sensors
          else -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        }
        locationOption.interval = time.toLong();
        watchClient.setLocationOption(locationOption)
        watchClient.startLocation()
        if (background!!) {
          watchClient.enableBackgroundLocation(2008071, buildNotification())
        }
        result.success(null)
      }
      "stop" -> {
        watchClient.stopLocation()
        watchClient.setLocationListener(null)
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun buildNotification(): Notification? {
    var builder: Notification.Builder? = null
    var notification: Notification? = null
    if (Build.VERSION.SDK_INT >= 26) {
      //Android O上对Notification进行了修改，如果设置的targetSDKVersion>=26建议使用此种方式创建通知栏
      if (null == notificationManager) {
//        notificationManager = getSystemService<Any>(Context.NOTIFICATION_SERVICE) as NotificationManager?
      }
      val channelId: String = "plugins.muka.com/amap_location_server"
      if (!isCreateChannel) {
        val notificationChannel = NotificationChannel(channelId,
                NOTIFICATION_CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT)
        notificationChannel.enableLights(true) //是否在桌面icon右上角展示小圆点
        notificationChannel.lightColor = Color.BLUE //小圆点颜色
        notificationChannel.setShowBadge(true) //是否在久按桌面图标时显示此渠道的通知
        notificationManager?.createNotificationChannel(notificationChannel)
        isCreateChannel = true
      }
      builder = Notification.Builder(pluginBinding.applicationContext, channelId)
    } else {
      builder = Notification.Builder(pluginBinding.applicationContext)
    }
    builder
            .setContentText("正在后台运行")
            .setWhen(System.currentTimeMillis())
    notification = if (Build.VERSION.SDK_INT >= 16) {
      builder.build()
    } else {
      return builder.notification
    }
    return notification
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
    eventChannel.setStreamHandler(null)
  }

  override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
    eventSink = events
  }

  override fun onCancel(arguments: Any?) {

  }
}
