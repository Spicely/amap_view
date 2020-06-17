import 'package:json_annotation/json_annotation.dart';

part 'index.g.dart';

@JsonSerializable()
class LocationPois {
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

  LocationPois(
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
  );

  factory LocationPois.fromJson(Map<dynamic, dynamic> json) => _$LocationPoisFromJson(json);

  Map<String, dynamic> toJson() => _$LocationPoisToJson(this);
}
