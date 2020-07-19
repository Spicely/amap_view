package com.muka.amap_view

import android.Manifest
import android.annotation.SuppressLint
import android.app.Activity
import android.app.Application
import android.content.Context
import android.location.Location
import android.os.Bundle
import android.util.Log
import android.view.View
import androidx.core.app.ActivityCompat
import io.flutter.plugin.common.StandardMessageCodec
import io.flutter.plugin.platform.PlatformView
import io.flutter.plugin.platform.PlatformViewFactory
import java.util.concurrent.atomic.AtomicInteger
import com.amap.api.maps.AMap
import com.amap.api.maps.AMapOptions
import com.amap.api.maps.TextureMapView
import com.amap.api.maps.model.*
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.amap.api.maps.model.LatLng
import com.muka.amap_view.AmapViewPlugin.Companion.CREATED
import com.muka.amap_view.AmapViewPlugin.Companion.DESTROYED
import com.muka.amap_view.AmapViewPlugin.Companion.PAUSED
import com.muka.amap_view.AmapViewPlugin.Companion.RESUMED
import com.muka.amap_view.AmapViewPlugin.Companion.STOPPED
import io.flutter.plugin.common.PluginRegistry


class AmapFactory(private val activityState: AtomicInteger, private val registrar: PluginRegistry.Registrar)
    : PlatformViewFactory(StandardMessageCodec.INSTANCE) {

    override fun create(context: Context, id: Int, args: Any): PlatformView {
        // 申请权限
        ActivityCompat.requestPermissions(registrar.activity(),
                arrayOf(Manifest.permission.ACCESS_COARSE_LOCATION,
                        Manifest.permission.ACCESS_FINE_LOCATION,
                        Manifest.permission.WRITE_EXTERNAL_STORAGE,
                        Manifest.permission.READ_EXTERNAL_STORAGE,
                        Manifest.permission.READ_PHONE_STATE),
                321
        )

        // 初始化地图
        val params = args as Map<String, Any>
        var opts = Convert.toUnifiedMapOptions(params.get("options"))
        var initialMarkers = params.get("markersToAdd")
        val view = AMapView(context, id, activityState, registrar, opts, initialMarkers)
        view.setup()

        return view
    }
}

@SuppressLint("CheckResult")
class AMapView(context: Context,
               id: Int,
               private val activityState: AtomicInteger,
               private val registrar: PluginRegistry.Registrar,
               private val options: UnifiedMapOptions,
               private val initialMarkers: Any?)
    : PlatformView,
        MethodChannel.MethodCallHandler,
        AMap.OnMapLoadedListener,
        AMap.OnMapClickListener,
        AMap.OnInfoWindowClickListener,
        AMap.OnMarkerClickListener,
        AMap.OnCameraChangeListener,
        AMap.OnMyLocationChangeListener,
        AmapOptionsSink,
        Application.ActivityLifecycleCallbacks {


    private val mapView: TextureMapView = TextureMapView(context, options.toAMapOptions())
    private var map: AMap
    private var mapReadyResult: MethodChannel.Result? = null
    private val methodChannel: MethodChannel
    private var disposed = false
    private val registrarActivityHashCode: Int
    private var markerController: MarkerController
    private val polylineController: PolylineController
    private var density = context.resources.displayMetrics.density

    init {
        map = mapView.map
        map.setOnMapLoadedListener(this)

        registrarActivityHashCode = registrar.activity().hashCode()

        // 双端通信channel
        methodChannel = MethodChannel(registrar.messenger(), "plugins.muka.com/amap_view_$id")
        methodChannel.setMethodCallHandler(this)

        // marker控制器
        markerController = MarkerController(methodChannel, mapView.map)

        // polyline控制器
        polylineController = PolylineController(methodChannel, mapView.map)
    }

    fun setup() {
        when (activityState.get()) {
            STOPPED -> {
                mapView.onCreate(null)
                mapView.onResume()
                mapView.onPause()
            }
            PAUSED -> {
                mapView.onCreate(null)
                mapView.onResume()
                mapView.onPause()
            }
            RESUMED -> {
                mapView.onCreate(null)
                mapView.onResume()
            }
            CREATED -> mapView.onCreate(null)
            DESTROYED -> {
            }
            else -> throw IllegalArgumentException(
                    "Cannot interpret " + activityState.get() + " as an activity state")
        } // Nothing to do, the activity has been completely destroyed.
        registrar.activity().application.registerActivityLifecycleCallbacks(this)
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "map#waitForMap" -> {
                mapReadyResult = result
            }
            "map#update" -> {
                var options: Any? = call.argument("options")
                Convert.updateMapOptions(options, this)
                result.success(null)
            }
            "markers#update" -> {
                var markersToAdd: Any? = call.argument("markersToAdd")
                var markersToChange: Any? = call.argument("markersToChange")
                var markerIdsToRemove: Any? = call.argument("markerIdsToRemove")
                // controller process
                markerController.addMarkers(markersToAdd as List<Any>)
                markerController.changeMarkers(markersToChange as List<Any>)
                markerController.removeMarkers(markerIdsToRemove as List<Any>)
                result.success(null)
            }
            "polylines#update" -> {
                var polylinesToAdd: Any? = call.argument("polylinesToAdd")
                var polylinesToChange: Any? = call.argument("polylinesToChange")
                var polylineIdsToRemove: Any? = call.argument("polylineIdsToRemove")
                // controller process
                polylineController.addPolylines(polylinesToAdd as List<Any>)
                polylineController.changePolylines(polylinesToChange as List<Any>)
                polylineController.removePolylines(polylineIdsToRemove as List<Any>)
                result.success(null)
            }
            "camera#move" -> {
                var cameraUpdate: Any? = call.argument("cameraUpdate")
                var camera = Convert.toCameraUpdate(cameraUpdate, density)
                if (camera != null) {
                    map.moveCamera(camera)
                }
                result.success(null)
            }
            "camera#animate" -> {
                var cameraUpdate: Any? = call.argument("cameraUpdate")
                var camera = Convert.toCameraUpdate(cameraUpdate, density)
                if (camera != null) {
                    map.animateCamera(camera)
                }
                result.success(null)
            }

            else -> result.notImplemented()
        }
    }

    override fun onMapLoaded() {
        mapReadyResult?.success(null)
        // 地图点击事件监听
        map.setOnMapClickListener(this)
        // 地图移动事件监听
        map.setOnCameraChangeListener(this)
        // 设置地图marker点击事件监听
        map.setOnMarkerClickListener(this)
        // 设置地图infowindow点击事件监听
        map.setOnInfoWindowClickListener(this)
        // 设置地图是否显示当前位置蓝点
        var myLocationEnable: Boolean = options.getMyLocationEnable()
        if (myLocationEnable) {
            map.isMyLocationEnabled = true
            var style = MyLocationStyle()
            style.myLocationType(options.getMyLocationStyle())
            // 设置蓝点类型
            map.myLocationStyle = style
            // 设置是否显示移动按钮
            map.uiSettings.isMyLocationButtonEnabled = true
            map.uiSettings.zoomPosition = AMapOptions.ZOOM_POSITION_RIGHT_BUTTOM
        }
        // 初始化markers
        updateInitialMarkers()

    }

    override fun getView(): View {
        return mapView
    }

    override fun dispose() {
        if (disposed) {
            return
        }
        disposed = true
        methodChannel.setMethodCallHandler(null)
        mapView.onDestroy()
        registrar.activity().application.unregisterActivityLifecycleCallbacks(this)
    }

    private fun updateInitialMarkers() {
        if (initialMarkers != null) {
            var markers = initialMarkers as List<Any>
            markerController.addMarkers(markers)
        }
    }

    // 地图监听事件
    override fun onMapClick(point: LatLng) {
        var p = Convert.toJson(point)
        var arguments = hashMapOf<String, Any>("position" to p)
        methodChannel.invokeMethod("map#onTap", arguments)
    }

    override fun onMarkerClick(marker: Marker): Boolean {
        if (marker.isInfoWindowShown) {
            marker.hideInfoWindow()
        } else {
            marker.showInfoWindow()
        }
        return markerController.onMarkerTap(marker.id)
    }

    override fun onInfoWindowClick(marker: Marker) {
        markerController.onInfoWindowTap(marker.id)
    }

    override fun onMyLocationChange(location: Location) {
        Log.d("onMyLocationChange", location.toString())
        var arguments = hashMapOf<String, Any?>(
                "location" to Convert.toJson(location)
        )
        methodChannel.invokeMethod("location#change", arguments)
    }

    override fun onCameraChange(position: CameraPosition) {
        var arguments = hashMapOf<String, Any?>(
                "position" to Convert.toJson(position)
        )
        methodChannel.invokeMethod("camera#onMove", arguments)
    }

    override fun onCameraChangeFinish(position: CameraPosition) {
        var arguments = hashMapOf<String, Any?>(
                "position" to Convert.toJson(position)
        )
        methodChannel.invokeMethod("camera#onIdle", arguments)
    }

    // AmapOptionsSink
    override fun setCompassEnabled(compassEnabled: Boolean) {
        map.uiSettings.isCompassEnabled = compassEnabled
    }

    override fun setMapType(mapType: Int) {
        map.mapType = mapType
    }

    override fun setMyLocationEnabled(myLocationEnabled: Boolean) {
        map.isMyLocationEnabled = myLocationEnabled
    }

    override fun setRotateGesturesEnabled(rotateGesturesEnabled: Boolean) {
        map.uiSettings.isRotateGesturesEnabled = rotateGesturesEnabled
    }

    override fun setScaleEnabled(scaleEnabled: Boolean) {
        map.uiSettings.isScaleControlsEnabled = scaleEnabled
    }

    override fun setScrollGesturesEnabled(scrollGesturesEnabled: Boolean) {
        map.uiSettings.isScrollGesturesEnabled = scrollGesturesEnabled
    }

    override fun setZoomGesturesEnabled(zoomGesturesEnabled: Boolean) {
        map.uiSettings.isZoomGesturesEnabled = zoomGesturesEnabled
    }

    override fun setZoomControlsEnabled(zoomControlsEnabled: Boolean) {
        map.uiSettings.isZoomControlsEnabled = zoomControlsEnabled
    }

    // 生命周期
    override fun onActivityCreated(activity: Activity, savedInstanceState: Bundle?) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onCreate(savedInstanceState)
    }

    override fun onActivityStarted(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivityResumed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onResume()
    }

    override fun onActivityPaused(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onPause()
    }

    override fun onActivityStopped(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
    }

    override fun onActivitySaveInstanceState(activity: Activity, outState: Bundle) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onSaveInstanceState(outState)
    }

    override fun onActivityDestroyed(activity: Activity) {
        if (disposed || activity.hashCode() != registrarActivityHashCode) {
            return
        }
        mapView.onDestroy()
    }
}
