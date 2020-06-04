package com.muka.amap_location

import com.amap.api.location.AMapLocation


class Convert {
    companion object {
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
    }
}