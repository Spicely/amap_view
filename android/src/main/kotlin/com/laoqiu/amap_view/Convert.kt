package com.laoqiu.amap_view

import android.location.Location
import com.amap.api.location.AMapLocation
import com.amap.api.maps.model.*
import com.amap.api.services.core.LatLonPoint
import com.amap.api.services.geocoder.RegeocodeAddress
import com.google.gson.Gson
import io.flutter.view.FlutterMain
import android.graphics.*
import android.graphics.BitmapFactory
import android.graphics.Bitmap
import android.os.AsyncTask
import android.util.Log
import com.amap.api.location.DPoint
import com.amap.api.maps.CameraUpdate
import com.amap.api.maps.CameraUpdateFactory
import com.amap.api.services.geocoder.GeocodeAddress
import com.amap.api.services.route.DrivePath
import com.amap.api.services.route.DriveStep
import java.io.IOException
import java.io.InputStream
import java.net.URL
import com.amap.api.maps.model.CameraPosition
import com.amap.api.maps.model.LatLngBounds
import com.amap.api.maps.model.LatLng
import com.amap.api.services.help.Tip
import com.amap.api.services.route.RidePath
import com.amap.api.services.route.RideStep


// Gson扩展方法
inline fun <reified T> Gson.fromJson(json: String) = fromJson(json, T::class.java)


class AsyncTaskLoadAvatar(
        private val marker: Marker,
        private val visible: Boolean,
        private val width: Int = 120,
        private val height: Int = 120,
        private val left: Float = 0f,
        private val top: Float = 0f,
        private val background: Bitmap?) : AsyncTask<String, String, Bitmap>() {

    override fun doInBackground(vararg params: String): Bitmap? {
        var bitmap: Bitmap? = null
        try {
            val url = URL(params[0])
            bitmap = BitmapFactory.decodeStream(url.content as InputStream)
        } catch (e: IOException) {
            Log.d("AsyncTaskLoadImage", e.message)
        }
        return bitmap
    }

    override fun onPostExecute(bitmap: Bitmap) {
        var photo = getCroppedBitmap(
                Bitmap.createScaledBitmap(bitmap, width, height, true), Math.min(width, height) / 2)
        if (background != null) photo = mergeBitmap(background, photo, left, top)
        marker.setIcon(BitmapDescriptorFactory.fromBitmap(photo))
        marker.setVisible(visible)
    }

    fun mergeBitmap(b1: Bitmap, b2: Bitmap, left: Float, top: Float): Bitmap {
        var bitmap = Bitmap.createBitmap(b1.width, b1.height, b1.config)
        var canvas = Canvas(bitmap)
        canvas.drawBitmap(b1, Matrix(), null)
        canvas.drawBitmap(b2, left, top, null)
        return bitmap
    }

}

fun drawTextToBitmap(bmp: Bitmap, text: String, size: Float, color: List<Int>, scale: Float, offsetX: Float = 0f, offsetY: Float = 0f): Bitmap {
    var bitmap = bmp.copy(Bitmap.Config.ARGB_8888, true)
    var canvas = Canvas(bitmap)
    var paint = Paint(Paint.ANTI_ALIAS_FLAG)
    paint.textSize = size
    paint.color = Color.rgb(color[0], color[1], color[2])
    paint.setShadowLayer(1f, 0f, 1f, Color.WHITE)
    val bounds = Rect()
    paint.getTextBounds(text, 0, text.length, bounds)
    val x = (bitmap.width - bounds.width()) / 2 + offsetX
    val y = bounds.height() + offsetY
    canvas.drawText(text, x, y, paint)
    return bitmap
}


fun getCroppedBitmap(bmp: Bitmap, radius: Int): Bitmap {
    val sbmp: Bitmap

    if (bmp.width !== radius || bmp.height !== radius) {
        val smallest = Math.min(bmp.width, bmp.height)
        val factor = smallest / radius
        sbmp = Bitmap.createScaledBitmap(bmp,
                bmp.width / factor,
                bmp.height / factor, false)
    } else {
        sbmp = bmp
    }

    val output = Bitmap.createBitmap(radius, radius, Bitmap.Config.ARGB_8888)
    val canvas = Canvas(output)

    val paint = Paint()
    val rect = Rect(0, 0, radius, radius)

    paint.setAntiAlias(true)
    paint.setFilterBitmap(true)
    paint.setDither(true)
    canvas.drawARGB(0, 0, 0, 0)
    paint.setColor(Color.parseColor("#BAB399"))
    canvas.drawCircle(radius / 2 + 0.7f, radius / 2 + 0.7f,
            radius / 2 + 0.1f, paint)
    paint.setXfermode(PorterDuffXfermode(PorterDuff.Mode.SRC_IN))
    canvas.drawBitmap(sbmp, rect, rect, paint)
    return output
}


class Convert {
    companion object {
        fun updateMapOptions(options: Any?, sink: AmapOptionsSink) {
            val opts = options as Map<String, Any>
            val compassEnabled = opts.get("compassEnabled")
            if (compassEnabled != null) {
                sink.setCompassEnabled(compassEnabled as Boolean)
            }
            val mapType = opts.get("mapType")
            if (mapType != null) {
                sink.setMapType(mapType as Int)
            }
            val myLocationEnabled = opts.get("myLocationEnabled")
            if (myLocationEnabled != null) {
                sink.setMyLocationEnabled(myLocationEnabled as Boolean)
            }
            val scaleControlsEnabled = opts.get("scaleControlsEnabled")
            if (scaleControlsEnabled != null) {
                sink.setScaleEnabled(scaleControlsEnabled as Boolean)
            }
            val zoomControlsEnabled = opts.get("zoomControlsEnabled")
            if (zoomControlsEnabled != null) {
                sink.setZoomControlsEnabled(zoomControlsEnabled as Boolean)
            }
            val scrollGesturesEnabled = opts.get("scrollGesturesEnabled")
            if (scrollGesturesEnabled != null) {
                sink.setScrollGesturesEnabled(scrollGesturesEnabled as Boolean)
            }
        }

        fun interpretMarkerOptions(marker: Marker, new: UnifiedMarkerOptions, old: UnifiedMarkerOptions?) {
            if (old == null) {
                interpretMarkerIcon(new.icon, marker)
            } else {
                if (old.visible != new.visible) {
                    marker.setVisible(new.visible)
                }
                if (old.flat != new.flat) {
                    marker.setFlat(new.flat)
                }
                if (old.alpha != new.alpha) {
                    marker.setAlpha(new.alpha)
                }
                if (old.infoWindow != new.infoWindow) {
                    if (new.infoWindow["snippet"] != null) {
                        marker.setSnippet(new.infoWindow["snippet"] as String)
                    }
                    if (new.infoWindow["title"] != null) {
                        marker.setTitle(new.infoWindow["title"] as String)
                    }
                }
                if (old.draggable != new.draggable) {
                    marker.setDraggable(new.draggable)
                }
                if (old.anchor != new.anchor) {
                    marker.setAnchor(new.anchor[0], new.anchor[1])
                }
                if (old.position != new.position) {
                    marker.setPosition(new.position)
                }
                if (old.rotation != new.rotation) {
                    marker.setRotateAngle(new.rotation)
                }
                if (old.zIndex != new.zIndex) {
                    marker.setZIndex(new.zIndex)
                }
                if (old.icon != new.icon) {
                    interpretMarkerIcon(new.icon, marker)
                }
            }

        }

        fun interpretMarkerIcon(o: Any?, marker: Marker) {
            var data = o as List<Any>
            var icon: BitmapDescriptor
            when (data[0].toString()) {
                "defaultMarker" -> {
                    if (data.size == 1) {
                        icon = BitmapDescriptorFactory.defaultMarker()
                    } else {
                        icon = BitmapDescriptorFactory.defaultMarker(toFloat(data[1]))
                    }
                    marker.setIcon(icon)
                }
                "fromAssetImage" -> {
                    if (data.size == 3) {
                        icon = BitmapDescriptorFactory.fromAsset(
                                FlutterMain.getLookupKeyForAsset(toString(data[1])))
                        marker.setIcon(icon)
                    } else {
                        throw IllegalArgumentException(
                                "'fromAssetImage' Expected exactly 3 arguments, got: " + data.size);
                    }
                }
                "fromAssetImageWithText" -> {
                    if (data.size == 4) {
                        icon = BitmapDescriptorFactory.fromAsset(
                                FlutterMain.getLookupKeyForAsset(toString(data[1])))
                        var scale = data[2] as Double
                        var label = data[3] as Map<String, Any>
                        var text = label.get("text") as String
                        var size = label.get("size") as Double
                        var color = label.get("color") as List<Int>
                        var offset = label.get("offset") as List<Float>
                        var bitmap = drawTextToBitmap(icon.bitmap, text, size.toFloat(), color, scale.toFloat(), offset[0], offset[1])
                        marker.setIcon(BitmapDescriptorFactory.fromBitmap(bitmap))
                    } else {
                        throw IllegalArgumentException(
                                "'fromAssetImage' Expected exactly 3 arguments, got: " + data.size);
                    }
                }
                "fromAvatarWithAssetImage" -> {
                    if (data.size == 4) {
                        // 网络图片的marker，等图片加载完成才显示
                        var visible: Boolean = marker.isVisible
                        if (visible) marker.setVisible(false)
                        var icon = BitmapDescriptorFactory.fromAsset(
                                FlutterMain.getLookupKeyForAsset(toString(data[1])))
                        var avatar = data[3] as Map<String, Any>
                        var url = avatar.get("url") as String
                        var size = avatar.get("size") as List<Int>
                        var offset = avatar.get("offset") as List<Float>
                        AsyncTaskLoadAvatar(marker, visible, size[0], size[1], offset[0], offset[1], icon.bitmap).execute(url)
                    } else {
                        throw IllegalArgumentException(
                                "'fromAvatarWithAssetImage' Expected exactly 4 arguments, got: " + data.size);
                    }
                }
                else -> throw IllegalArgumentException("Cannot interpret " + o + " as BitmapDescriptor")
            }
        }

        fun interpretPolylineOptions(polyline: Polyline, new: UnifiedPolylineOptions, old: UnifiedPolylineOptions?) {
            if (old == null) {
              return
            }
            if (old.visible != new.visible) {
                polyline.isVisible = new.visible
            }
            if (old.color != new.color) {
                polyline.color = new.color.toInt()
            }
            if (old.points != new.points) {
                polyline.points = new.points
            }
            if (old.width != new.width) {
                polyline.width = new.width
            }
        }

        fun toUnifiedMapOptions(options: Any?): UnifiedMapOptions {
            var data = options as Map<String, Any>
            return Gson().fromJson<UnifiedMapOptions>(Gson().toJson(data))
        }

        fun toUnifiedMarkerOptions(options: Any): UnifiedMarkerOptions {
            var data = options as Map<String, Any>
            return Gson().fromJson<UnifiedMarkerOptions>(Gson().toJson(data))
        }

        fun toUnifiedPolylineOptions(options: Any?): UnifiedPolylineOptions {
            var data = options as Map<String, Any>
            return Gson().fromJson<UnifiedPolylineOptions>(Gson().toJson(data))
        }

        fun toCameraUpdate(o: Any?, density: Float): CameraUpdate? {
            if (o == null) {
                return null
            }
            var data = toList(o)
            when (toString(data.get(0))) {
               "newCameraPosition" -> {
                   return CameraUpdateFactory.newCameraPosition(
                           toCameraPosition(data.get(1)))
               }
                "newLatLng" -> {
                    return CameraUpdateFactory.newLatLng(toLatLng(data.get(1)))
                }
                "newLatLngBounds" -> {
                    return CameraUpdateFactory.newLatLngBounds(
                            toLatLngBounds(data.get(1)), toPixels(data.get(2), density))
                }
                "newLatLngZoom" -> {
                    return CameraUpdateFactory.newLatLngZoom(
                            toLatLng(data.get(1)), toFloat(data.get(2)))
                }
                "zoomBy" -> {
                    return CameraUpdateFactory.zoomBy(toFloat(data.get(1)))
                }
                "zoomIn" -> {
                    return CameraUpdateFactory.zoomIn()
                }
                "zoomOut" -> {
                    return CameraUpdateFactory.zoomOut()
                }
                else -> {
                    return null
                }
            }
        }

        fun markerIdToJson(markerId: String): Any {
            var data = hashMapOf<String, Any>(
                    "markerId" to markerId
            )
            return data
        }

        fun polylineIdToJson(polylineId: String): Any {
            var data = hashMapOf<String, Any>(
                    "polylineId" to polylineId
            )
            return data
        }

        fun toLatLngBounds(o: Any): LatLngBounds? {
            if (o == null) {
                return null
            }
            val builder = LatLngBounds.Builder()
            var data = toList(o)
            for (i in data) {
                var d = toLatLng(i)
                if (d != null) builder.include(d)
            }
            return builder.build()
        }

        fun toLatLng(o: Any?): LatLng? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            var latitude = data.get("latitude")
            var longitude = data.get("longitude")
            if (latitude != null && longitude != null) {
                return LatLng(toDouble(latitude), toDouble(longitude))
            }
            return null
        }

        fun toPoi(o: Any?): Poi? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            var name = data.get("name")
            var target = toLatLng(data.get("target"))
            var s1 = data.get("s1") as String
            if (name != null && target != null) {
                return Poi(toString(name), target, s1)
            }
            return null
        }

        fun toLatLntPoint(latLng: LatLng): LatLonPoint {
            return LatLonPoint(latLng.latitude, latLng.longitude)
        }

        fun toWayList(o: Any?): List<LatLonPoint>? {
            if (o == null) {
                return null
            }
            var result = mutableListOf<LatLonPoint>()
            var data = toList(o)
            for (i in data) {
                var latLng= toLatLng(i)
                if (latLng != null) {
                    result.add(toLatLntPoint(latLng))
                }
            }
            return result
        }

        fun toCameraPosition(o: Any): CameraPosition {
            val data = toMap(o)
            val builder = CameraPosition.Builder()
            if (data["bearing"] != null) builder.bearing(toFloat(data["bearing"]!!))
            if (data["tilt"] != null) builder.tilt(toFloat(data["tilt"]!!))
            if (data["zoom"] != null) builder.zoom(toFloat(data["zoom"]!!))
            builder.target(toLatLng(data["target"]))
            return builder.build()
        }

        fun addressToJson(list: List<GeocodeAddress>): Any {
            val data = mutableListOf<Any>()
            for (address in list) {
                data.add(toJson(address))
            }
            return data
        }

        fun pathToJson(list: MutableList<DrivePath>): Any {
            val data = mutableListOf<Any>()
            for (path in list) {
                data.add(toJson(path))
            }
            return data
        }

        fun rideToJson(list: MutableList<RidePath>): Any {
            val data = mutableListOf<Any>()
            for (ride in list) {
                data.add(toJson(ride))
            }
            return data
        }

        fun tipsToJson(list: MutableList<Tip>): Any {
            val data = mutableListOf<Any>()
            if (list != null) {
                for (tip in list) {
                    data.add(toJson(tip))
                }
            }
            return data
        }

        fun polylineToJson(list: List<LatLonPoint>): Any {
            val data = mutableListOf<Any>()
            for (point in list) {
                data.add(toJson(point))
            }
            return data
        }

        fun toFractionalPixels(o: Any, density: Float): Float {
            return toFloat(o) * density
        }

        fun toPixels(o: Any, density: Float): Int {
            return toFractionalPixels(o, density).toInt()
        }

        fun toJson(latLng: LatLng): Any {
            // return Arrays.asList(latLng.latitude, latLng.longitude)
            val data = HashMap<String, Any>()
            data.put("latitude", latLng.latitude)
            data.put("longitude", latLng.longitude)
            return data
        }

        fun toJson(tip: Tip): Any {
            val data = HashMap<String, Any>()
            data.put("adcode", tip.adcode)
            data.put("address", tip.address)
            data.put("district", tip.district)
            data.put("name", tip.name)
            data.put("typeCode", tip.typeCode)
            if (tip.point != null) data.put("point", toJson(tip.point))
            return data
        }

        fun toJson(location: Location): Any {
            val data = HashMap<String, Any>()
            data.put("latitude", location.latitude)
            data.put("longitude", location.longitude)
            data.put("accuracy", location.accuracy)
            data.put("speed", location.speed)
            data.put("time", location.time)
            return data
        }

        fun toJson(position: CameraPosition): Any {
            val data = HashMap<String, Any>()
            data.put("bearing", position.bearing)
            data.put("target", toJson(position.target))
            data.put("tilt", position.tilt)
            data.put("zoom", position.zoom)
            return data
        }

        fun toJson(location: AMapLocation): Any {
            val data = HashMap<String, Any>()
            data.put("latitude", location.latitude)
            data.put("longitude", location.longitude)
            data.put("accuracy", location.accuracy)
            data.put("speed", location.speed)
            data.put("time", location.time)
            // 以下是定位sdk返回的逆地理信息
            data.put("coordType", location.coordType)
            data.put("country", location.country)
            data.put("city", location.city)
            data.put("district", location.district)
            data.put("street", location.street)
            data.put("address", location.address)
            return data
        }

        fun toJson(address: RegeocodeAddress): Any {
            val data = HashMap<String, Any>()
            data.put("country", address.country)
            data.put("province", address.province)
            data.put("city", address.city)
            data.put("district", address.district)
            data.put("township", address.township)
            data.put("street", address.streetNumber.street + address.streetNumber.number)
            data.put("building", address.building)
            data.put("formatted_address", address.formatAddress)
            data.put("neighborhood", address.neighborhood)
            data.put("ad_code", address.adCode)
            return data
        }

        fun toJson(address: GeocodeAddress): Any {
            val data = HashMap<String, Any>()
            data.put("adcode", address.adcode)
            data.put("province", address.province)
            data.put("city", address.city)
            data.put("district", address.district)
            data.put("township", address.township)
            data.put("building", address.building)
            data.put("formatted_address", address.formatAddress)
            data.put("neighborhood", address.neighborhood)
            data.put("latitude", address.latLonPoint.latitude)
            data.put("longitude", address.latLonPoint.longitude)
            return data
        }

        fun toJson(point: LatLonPoint): Any {
            val data = HashMap<String, Any>()
            data.put("longitude", point.longitude)
            data.put("latitude", point.latitude)
            return data
        }

        fun toJson(path: DrivePath): Any {
            val data = HashMap<String, Any>()
            val steps = mutableListOf<Any>()
            for (s in path.steps) {
                steps.add(toJson(s))
            }
            data.put("steps", steps)
            data.put("strategy", path.strategy)
            return data
        }

        fun toJson(step: DriveStep): Any {
            val data = HashMap<String, Any>()
            data.put("polyline", polylineToJson(step.polyline))
            data.put("distance", step.distance)
            data.put("duration", step.duration)
            return data
        }

        fun toJson(path: RidePath): Any {
            val data = HashMap<String, Any>()
            val steps = mutableListOf<Any>()
            for (s in path.steps) {
                steps.add(toJson(s))
            }
            data.put("steps", steps)
            data.put("distance", path.distance)
            data.put("duration", path.duration)
            return data
        }

        fun toJson(step: RideStep): Any {
            val data = HashMap<String, Any>()
            data.put("polyline", polylineToJson(step.polyline))
            data.put("distance", step.distance)
            data.put("duration", step.duration)
            data.put("action", step.action)
            data.put("assistantAction", step.assistantAction)
            data.put("orientation", step.orientation)
            data.put("road", step.road)
            return data
        }


        fun toJson(point: DPoint): Any {
            val data = HashMap<String, Any>()
            data.put("latitude", point.latitude)
            data.put("longitude", point.longitude)
            return data
        }

        fun toDouble(o: Any): Double {
            return o as Double
        }

        fun toFloat(o: Any): Float {
            return o as Float
        }

        fun toString(o: Any): String {
            return o as String
        }

        fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }

        fun toList(o: Any): List<Any> {
            return o as List<Any>
        }

        fun toInt(o: Any): Int {
            return (o as Number).toInt()
        }
    }

}


