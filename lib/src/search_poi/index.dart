part of amap_core;

class SearchPoi {
  ///POI全局唯一ID
  final String uid;

  ///名称
  final String name;

  ///兴趣点类型
  final String type;

  ///类型编码
  final String typecode;

  ///地址
  final String address;

  ///电话
  final String tel;

  ///距中心点的距离，单位米。在周边搜索时有效
  final double distance;

  ///停车场类型，地上、地下、路边
  final String parkingType;

  ///商铺id
  final String shopID;

  ///邮编
  final String postcode;

  ///网址
  final String website;

  ///电子邮件
  final String email;

  ///省
  final String province;

  ///省编码
  final String pcode;

  ///城市名称
  final String city;

  ///城市编码
  final String citycode;

  ///区域名称
  final String district;

  ///区域编码
  final String adcode;

  ///地理格ID
  final String gridcode;

  ///方向
  final String direction;

  ///是否有室内地图
  final bool hasIndoorMap;

  ///所在商圈
  final String businessArea;

  /// 纬度（垂直方向）
  final double latitude;

  /// 经度（水平方向）
  final double longitude;
// ///室内信息
// @property (nonatomic, strong) AMapIndoorData *indoorData;
// ///子POI列表
// @property (nonatomic, strong) NSArray<AMapSubPOI *> *subPOIs;
// ///图片列表
// @property (nonatomic, strong) NSArray<AMapImage *> *images;

  SearchPoi(
    this.adcode,
    this.address,
    this.businessArea,
    this.city,
    this.citycode,
    this.province,
    this.direction,
    this.distance,
    this.district,
    this.email,
    this.gridcode,
    this.hasIndoorMap,
    this.name,
    this.parkingType,
    this.pcode,
    this.postcode,
    this.shopID,
    this.tel,
    this.type,
    this.typecode,
    this.uid,
    this.website,
    this.latitude,
    this.longitude,
  );

  factory SearchPoi.fromJson(Map<dynamic, dynamic> json) => _$SearchPoiFromJson(json);

  Map<String, dynamic> toJson() => _$SearchPoiToJson(this);
}

SearchPoi _$SearchPoiFromJson(Map<dynamic, dynamic> json) {
  return SearchPoi(
      json['adcode'] as String,
      json['address'] as String,
      json['businessArea'] as String,
      json['city'] as String,
      json['citycode'] as String,
      json['province'] as String,
      json['direction'] as String,
      (json['distance'] as num)?.toDouble(),
      json['district'] as String,
      json['email'] as String,
      json['gridcode'] as String,
      json['hasIndoorMap'] as bool,
      json['name'] as String,
      json['parkingType'] as String,
      json['pcode'] as String,
      json['postcode'] as String,
      json['shopID'] as String,
      json['tel'] as String,
      json['type'] as String,
      json['typecode'] as String,
      json['uid'] as String,
      json['website'] as String,
      (json['latitude'] as num)?.toDouble(),
      (json['longitude'] as num)?.toDouble());
}

Map<String, dynamic> _$SearchPoiToJson(SearchPoi instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'type': instance.type,
      'typecode': instance.typecode,
      'address': instance.address,
      'tel': instance.tel,
      'distance': instance.distance,
      'parkingType': instance.parkingType,
      'shopID': instance.shopID,
      'postcode': instance.postcode,
      'website': instance.website,
      'email': instance.email,
      'province': instance.province,
      'pcode': instance.pcode,
      'city': instance.city,
      'citycode': instance.citycode,
      'district': instance.district,
      'adcode': instance.adcode,
      'gridcode': instance.gridcode,
      'direction': instance.direction,
      'hasIndoorMap': instance.hasIndoorMap,
      'businessArea': instance.businessArea,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
