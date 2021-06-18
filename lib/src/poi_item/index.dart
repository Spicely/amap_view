part of amap_core;

class PoiItem {
  /// POI全局唯一ID
  final String poiId;

  /// 名称
  final String name;

  /// 兴趣点类型
  final String typeDes;

  /// 类型编码
  final String typeCode;

  /// 地址
  final String address;

  /// 电话
  final String tel;

  /// 距中心点的距离，单位米。在周边搜索时有效
  final int distance;

  /// 停车场类型，地上、地下、路边
  final String parkingType;

  /// 商铺id
  final String shopID;

  /// 邮编
  final String postcode;

  /// 网址
  final String website;

  /// 电子邮件
  final String email;

  /// 省
  final String province;

  /// 省编码
  final String provinceCode;

  /// 城市名称
  final String city;

  /// 城市编码
  final String cityCode;

  /// 区域编码
  final String adCode;

  /// 区域名称
  final String direction;

  /// 是否有室内地图
  final bool isIndoorMap;

  /// 所在商圈
  final String businessArea;

  /// 纬度（垂直方向）
  final double latitude;

  /// 经度（水平方向）
  final double longitude;

  PoiItem(
    this.poiId,
    this.name,
    this.typeDes,
    this.typeCode,
    this.address,
    this.tel,
    this.distance,
    this.parkingType,
    this.shopID,
    this.postcode,
    this.website,
    this.email,
    this.province,
    this.provinceCode,
    this.city,
    this.cityCode,
    this.adCode,
    this.direction,
    this.isIndoorMap,
    this.businessArea,
    this.latitude,
    this.longitude,
  );

  factory PoiItem.fromJson(Map<dynamic, dynamic> json) => _$PoiItemFromJson(json);

  Map<String, dynamic> toJson() => _$PoiItemToJson(this);
}

PoiItem _$PoiItemFromJson(Map<dynamic, dynamic> json) {
  return PoiItem(
      json['poiId'] as String,
      json['name'] as String,
      json['typeDes'] as String,
      json['typeCode'] as String,
      json['address'] as String,
      json['tel'] as String,
      json['distance'] as int,
      json['parkingType'] as String,
      json['shopID'] as String,
      json['postcode'] as String,
      json['website'] as String,
      json['email'] as String,
      json['province'] as String,
      json['provinceCode'] as String,
      json['city'] as String,
      json['cityCode'] as String,
      json['adCode'] as String,
      json['direction'] as String,
      json['isIndoorMap'] as bool,
      json['businessArea'] as String,
      (json['latitude'] as num).toDouble(),
      (json['longitude'] as num).toDouble());
}

Map<String, dynamic> _$PoiItemToJson(PoiItem instance) => <String, dynamic>{
      'poiId': instance.poiId,
      'name': instance.name,
      'typeDes': instance.typeDes,
      'typeCode': instance.typeCode,
      'address': instance.address,
      'tel': instance.tel,
      'distance': instance.distance,
      'parkingType': instance.parkingType,
      'shopID': instance.shopID,
      'postcode': instance.postcode,
      'website': instance.website,
      'email': instance.email,
      'province': instance.province,
      'provinceCode': instance.provinceCode,
      'city': instance.city,
      'citycode': instance.cityCode,
      'adCode': instance.adCode,
      'direction': instance.direction,
      'isIndoorMap': instance.isIndoorMap,
      'businessArea': instance.businessArea,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
