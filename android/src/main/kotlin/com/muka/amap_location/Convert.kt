package com.muka.amap_location

import com.amap.api.location.AMapLocation
import com.amap.api.location.DPoint
import com.amap.api.services.geocoder.RegeocodeResult


class Convert {
    companion object {
        fun toJson(location: AMapLocation): HashMap<String, Any> {
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

        fun toJson(result: RegeocodeResult): HashMap<String, Any> {
            val data = HashMap<String, Any>()
            data["building"] = result.regeocodeAddress.building
            data["towncode"] = result.regeocodeAddress.towncode
            data["township"] = result.regeocodeAddress.township
            data["adcode"] = result.regeocodeAddress.adCode
            data["city"] = result.regeocodeAddress.city
            data["citycode"] = result.regeocodeAddress.cityCode
            data["neighborhood"] = result.regeocodeAddress.neighborhood
            data["country"] = result.regeocodeAddress.country
            data["formatAddress"] = result.regeocodeAddress.formatAddress
            data["province"] = result.regeocodeAddress.province
            data["district"] = result.regeocodeAddress.district
            data["streetNumber"] = result.regeocodeAddress.streetNumber.number
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