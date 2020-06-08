package com.muka.amap_search
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
    }
}