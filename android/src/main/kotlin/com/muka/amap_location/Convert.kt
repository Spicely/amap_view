package com.muka.amap_location

import com.amap.api.location.AMapLocation
import com.amap.api.location.DPoint


class Convert {
    companion object {
        fun toJson(location: AMapLocation): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = location.latitude
            data["longitude"] = location.longitude
            data["accuracy"] = location.accuracy
            data["speed"] = location.speed
            data["time"] = location.time
            // 以下是定位sdk返回的逆地理信息
            data["coordType"] = location.coordType
            data["country"] = location.country
            data["city"] = location.city
            data["district"] = location.district
            data["street"] = location.street
            data["address"] = location.address
            return data
        }

        fun toJson(point: DPoint): Any {
            val data = HashMap<String, Any>()
            data["latitude"] = point.latitude
            data["longitude"] = point.longitude
            return data
        }

        private fun toMap(o: Any): HashMap<String, Any> {
            return o as HashMap<String, Any>
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
    }
}