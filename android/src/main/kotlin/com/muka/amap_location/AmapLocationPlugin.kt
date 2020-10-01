package com.muka.amap_location

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.BitmapFactory
import android.graphics.Color
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
import kotlin.random.Random


/** AmapLocationPlugin */
public class AmapLocationPlugin : FlutterPlugin, MethodCallHandler, EventChannel.StreamHandler {

    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private lateinit var pluginBinding: FlutterPlugin.FlutterPluginBinding
    private var eventSink: EventChannel.EventSink? = null
    private lateinit var watchClient: AMapLocationClient
    private var channelId: String = "plugins.muka.com/amap_location_server"
    private var notificationManager: NotificationManager? = null
    private var isCreateChannel = false

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
                locationOption.locationMode = when (mode) {
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
                    locationClient.stopLocation()
                }
                locationClient.startLocation()
            }
            "start" -> {
                var mode: Any? = call.argument("mode")
                var time: Int = call.argument<Int>("time") ?: 2000
                var locationOption = AMapLocationClientOption()
                locationOption.locationMode = when (mode) {
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
                result.success(null)
            }
            "enableBackground" -> {
                watchClient.enableBackgroundLocation(2001, buildNotification(call.argument("title")
                        ?: "", call.argument("label") ?: "", call.argument("assetName")
                        ?: "", call.argument<Boolean>("vibrate")!!))
                result.success(null)
            }
            "disableBackground" -> {
                watchClient.disableBackgroundLocation(true)
                notificationManager?.deleteNotificationChannel(channelId)
                result.success(null)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun buildNotification(title: String, label: String, name: String, vibrate: Boolean): Notification? {
        var builder: Notification.Builder? = null
        var notification: Notification? = null
        if (Build.VERSION.SDK_INT >= 26) {
            if (null == notificationManager) {
                notificationManager = pluginBinding.applicationContext.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            }
            if(!isCreateChannel) {
                var notificationChannel = NotificationChannel(channelId, pluginBinding.applicationContext.packageName, NotificationManager.IMPORTANCE_HIGH);
                notificationChannel.enableLights(true) //是否在桌面icon右上角展示小圆点
                notificationChannel.lightColor = Color.BLUE //小圆点颜色
                notificationChannel.setShowBadge(true) //是否在久按桌面图标时显示此渠道的通知
                if (!vibrate) {
                    notificationChannel.enableVibration(false)
                    notificationChannel.vibrationPattern = null
                    notificationChannel.setSound(null, null)
                }
                notificationManager?.createNotificationChannel(notificationChannel);
            }
            builder = Notification.Builder(pluginBinding.applicationContext, channelId)
        } else {
            builder = Notification.Builder(pluginBinding.applicationContext)
        }
        var intent = Intent(pluginBinding.applicationContext, getMainActivityClass(pluginBinding.applicationContext))
        var pendingIntent = PendingIntent.getActivity(pluginBinding.applicationContext, Random.nextInt(100), intent, PendingIntent.FLAG_UPDATE_CURRENT)

        builder
                .setContentTitle(title).setContentText(label)
                .setWhen(System.currentTimeMillis())
                .setSmallIcon(getDrawableResourceId(name))
                .setLargeIcon(BitmapFactory.decodeResource(pluginBinding.applicationContext.resources, getDrawableResourceId(name)))
                .setContentIntent(pendingIntent)
        if (!vibrate) {
            builder.setDefaults(NotificationCompat.FLAG_ONLY_ALERT_ONCE)
        }
        if (Build.VERSION.SDK_INT >= 16) {
            notification = builder.build();
        } else {
            return builder.getNotification();
        }
        return notification
    }

    private fun getMainActivityClass(context: Context): Class<*>? {
        val packageName = context.packageName
        val launchIntent = context.packageManager.getLaunchIntentForPackage(packageName)
        val className = launchIntent.component.className
        return try {
            Class.forName(className)
        } catch (e: ClassNotFoundException) {
            e.printStackTrace()
            null
        }
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
