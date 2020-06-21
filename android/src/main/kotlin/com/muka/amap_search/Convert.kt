package com.muka.amap_search

import com.amap.api.location.DPoint
import com.amap.api.maps.model.LatLng
import com.amap.api.services.geocoder.RegeocodeResult
import com.amap.api.services.help.Tip
import com.amap.api.services.poisearch.PoiResult

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

        fun toJson(result: RegeocodeResult): Any {
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

        fun toArr(result: PoiResult): Any {
            val arr = mutableListOf<Any>()
            result.pois.forEachIndexed { index, it ->
                run {
                    val data = HashMap<String, Any>()
                    data["uid"] = it.poiId
                    data["name"] = it.adName
                    data["type"] = it.typeDes
                    data["typecode"] = it.typeCode
                    data["address"] = it.snippet
                    data["tel"] = it.tel
                    data["distance"] = it.distance
                    data["parkingType"] = it.parkingType
                    data["shopID"] = it.shopID
                    data["postcode"] = it.postcode
                    data["website"] = it.website
                    data["email"] = it.email
                    data["province"] = it.provinceName
                    data["pcode"] = it.provinceCode
                    data["city"] = it.cityName
                    data["citycode"] = it.cityCode
                     data["district"] = it.adName
                    data["adcode"] = it.postcode
                    // data["gridcode"] = it.id
                    data["direction"] = it.direction
                    data["hasIndoorMap"] = it.isIndoorMap
                    data["businessArea"] = it.businessArea
                    data["latitude"] = it.latLonPoint.latitude
                    data["longitude"] = it.latLonPoint.longitude
                    arr.add(data)
                }
            }
            return arr
        }

        fun toArr(result: MutableList<Tip>): Any {
            val arr = mutableListOf<Any>()
            result.forEachIndexed { index, it ->
                run {
                    val data = HashMap<String, Any>()
                    data["adcode"] = it.adcode
                    data["address"] = it.address
                    data["district"] = it.district
                    data["name"] = it.name
                    data["typecode"] = it.typeCode
                    data["uid"] = it.poiID
                    data["latitude"] = it.point.latitude
                    data["longitude"] = it.point.longitude
                    arr.add(data)
                }
            }
            return arr
        }
    }
}