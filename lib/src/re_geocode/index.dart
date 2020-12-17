part of amap_core;

class ReGeocode {
  /// 建筑
  final String? building;

  /// 乡镇街道编码
  final String? towncode;

  /// 乡镇街道
  final String? township;

  /// 区域编码
  final String? adcode;

  /// 市
  final String? city;

  /// 城市编码
  final String? citycode;

  /// 社区
  final String? neighborhood;

  /// 国家
  final String? country;

  /// 格式化地址
  final String? formatAddress;

  /// 省/直辖市
  final String? province;

  /// 区
  final String? district;

  /// 门牌信息
  final String? streetNumber;

  /// 兴趣点信息 AMapPOI 数组
  List<ReGeocode?>? pois = [];

  ReGeocode({
    this.adcode,
    this.citycode,
    this.country,
    this.formatAddress,
    this.province,
    this.towncode,
    this.township,
    this.pois,
    this.building,
    this.city,
    this.district,
    this.neighborhood,
    this.streetNumber,
  });

  factory ReGeocode.fromJson(Map<dynamic, dynamic> json) => _$ReGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$ReGeocodeToJson(this);
}

ReGeocode _$ReGeocodeFromJson(Map<dynamic, dynamic> json) {
  return ReGeocode(
    adcode: json['adcode'] as String?,
    citycode: json['citycode'] as String?,
    country: json['country'] as String?,
    formatAddress: json['formatAddress'] as String?,
    province: json['province'] as String?,
    towncode: json['towncode'] as String?,
    township: json['township'] as String?,
    pois: (json['pois'] as List?)?.map((e) => e == null ? null : ReGeocode.fromJson(new Map<String, dynamic>.from(e))).toList(),
    building: json['building'] as String?,
    city: json['city'] as String?,
    district: json['district'] as String?,
    neighborhood: json['neighborhood'] as String?,
    streetNumber: json['streetNumber'] as String?,
  );
}

Map<String, dynamic> _$ReGeocodeToJson(ReGeocode instance) => <String, dynamic>{
      'towncode': instance.towncode,
      'township': instance.township,
      'adcode': instance.adcode,
      'citycode': instance.citycode,
      'country': instance.country,
      'formatAddress': instance.formatAddress,
      'province': instance.province,
      'pois': instance.pois,
      'building': instance.building,
      'city': instance.city,
      'streetNumber': instance.streetNumber,
      'district': instance.district,
      'neighborhood': instance.neighborhood
    };
