package com.muka.amap_location

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.os.Build
import androidx.annotation.NonNull
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
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
  private val channelId: String = "plugins.muka.com/amap_location_server"

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
        var locationOption = AMapLocationClientOption()
        locationOption.locationMode = when(mode) {
          1 -> AMapLocationClientOption.AMapLocationMode.Battery_Saving
          2 -> AMapLocationClientOption.AMapLocationMode.Device_Sensors
          else -> AMapLocationClientOption.AMapLocationMode.Hight_Accuracy
        }
        locationOption.interval = time.toLong();
        watchClient.setLocationOption(locationOption)
        watchClient.startLocation()
        result.success(null)
      }
      "stop" -> {
        watchClient.stopLocation()
        watchClient.setLocationListener(null)
        result.success(null)
      }
      "enableBackground" -> {
        watchClient.enableBackgroundLocation(1, buildNotification(call.argument("title")?:"",call.argument("label")?:"", call.argument("assetName")?:"",call.argument<Boolean>("vibrate")!!))
        result.success(null)
      }
      "disableBackground" -> {
        watchClient.disableBackgroundLocation(true)
        result.success(null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  private fun buildNotification(title: String, label: String, name: String, vibrate: Boolean): Notification? {

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
      var notificationChannel = NotificationChannel(channelId, "test", NotificationManager.IMPORTANCE_HIGH);
      val notificationManager = pluginBinding.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
      notificationManager.createNotificationChannel(notificationChannel);
    }
    var intent = Intent(pluginBinding.applicationContext, this.javaClass)
    var pendingIntent = PendingIntent.getActivity(pluginBinding.applicationContext,0, intent, 0)

    var notification = NotificationCompat.Builder(pluginBinding.applicationContext,  channelId).
    setContentTitle(title).
    setContentText(label).
    setWhen(System.currentTimeMillis()).
    setSmallIcon(getDrawableResourceId(name)).
    setLargeIcon(BitmapFactory.decodeResource(pluginBinding.applicationContext.resources, getDrawableResourceId(name))).
    setContentIntent(pendingIntent)
    if (!vibrate) {
      notification.setDefaults(NotificationCompat.FLAG_ONLY_ALERT_ONCE)
    }
    return notification.build()
  }

  private fun getDrawableResourceId(name: String): Int {
    return pluginBinding.applicationContext.resources.getIdentifier(name, "drawable", pluginBinding.applicationContext.packageName)
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
