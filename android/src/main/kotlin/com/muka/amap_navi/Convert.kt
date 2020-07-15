package com.muka.amap_navi

import com.amap.api.maps.model.LatLng
import com.amap.api.maps.model.Poi


class Convert {
    companion object {
        fun toDouble(o: Any): Double {
            return o as Double
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

        fun toString(o: Any): String {
            return o as String
        }

        fun toPoi(o: Any?): Poi? {
            if (o == null) {
                return null
            }
            var data = toMap(o)
            var name = data["name"]
            var target = toLatLng(data["target"])
            var s1 = data["s1"] as String
            if (name != null && target != null) {
                return Poi(toString(name), target, s1)
            }
            return null
        }

        fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
        }
    }

}

