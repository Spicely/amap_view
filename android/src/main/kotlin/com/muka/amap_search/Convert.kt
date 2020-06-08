package com.muka.amap_search
import com.amap.api.location.DPoint
import com.amap.api.maps.model.LatLng

class Convert {
    companion object {


        private fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }

        fun toLatLng(o: Any?): LatLng? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            var latitude = data["latitude"]
            var longitude = data["longitude"]
            if (latitude != null && longitude != null) {
                return LatLng(toDouble(latitude), toDouble(longitude))
            }
            return null
        }

        fun toDouble(o: Any): Double {
            return o as Double
        }

        fun toDPoint(o: Any?): DPoint? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            if (data["latitude"] != null && data["longitude"] != null) {
                return DPoint(data["latitude"] as Double, data["longitude"] as Double)
            }
            return null
        }

        fun toJson(point: DPoint): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = point.latitude
            data["longitude"] = point.longitude
            return data
        }
    }
}