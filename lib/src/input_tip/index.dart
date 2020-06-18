part of amap_search;

class InputTip {
  /// 区域编码
  final String adcode;

  /// 地址
  final String address;

  /// 所属区域
  final String district;

  /// 名称
  final String name;

  /// 类型编码
  final String typecode;

  /// POI全局唯一ID
  final String uid;

  /// 纬度（垂直方向）
  final double latitude;

  /// 经度（水平方向）
  final double longitude;

  InputTip(
    this.adcode,
    this.address,
    this.district,
    this.name,
    this.typecode,
    this.uid,
    this.latitude,
    this.longitude,
  );

  factory InputTip.fromJson(Map<dynamic, dynamic> json) => _$InputTipFromJson(json);

  Map<String, dynamic> toJson() => _$InputTipToJson(this);
}

InputTip _$InputTipFromJson(Map<dynamic, dynamic> json) {
  return InputTip(json['uid'] as String, json['name'] as String, json['typecode'] as String, json['address'] as String,
      json['district'] as String, json['adcode'] as String, (json['latitude'] as num)?.toDouble(), (json['longitude'] as num)?.toDouble());
}

Map<String, dynamic> _$InputTipToJson(InputTip instance) => <String, dynamic>{
      'uid': instance.uid,
      'name': instance.name,
      'typecode': instance.typecode,
      'address': instance.address,
      'district': instance.district,
      'adcode': instance.adcode,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
    };
