part of amap_view;

class AmapSearch {
  static const MethodChannel _channel = const MethodChannel('plugins.laoqiu.com/amap_view_search');

  /// 逆地理编码（坐标转地址）
  static Future<dynamic> reGeocode(
    LatLng point, {
    LatLntType latLntType,
    double radius,
  }) async {
    return await _channel.invokeMethod('search#reGeocode', {
      "latLntType": latLntType.index,
      "point": point?.toMap(),
      "radius": radius,
    });
  }

  /// 地理编码（地址转坐标）
  static Future<List<Geocode>> geocode(
    String address, {
    String city,
  }) async {
    List<dynamic> res = await _channel.invokeMethod('search#geocode', {
      "address": address,
      "city": city,
    });
    return res.map((e) => Geocode.fromJson(e)).toList();
  }

  /// 行车路径规划
  static Future<dynamic> route({
    @required LatLng start,
    @required LatLng end,
    List<LatLng> wayPoints,
    RouteType routeType,
  }) async {
    return await _channel.invokeMethod('search#route', {
      "start": start.toMap(),
      "naviType": routeType.index,
      "end": end.toMap(),
      "wayPoints": wayPoints?.map((i) => i.toMap())?.toList(),
    });
  }
}

enum RouteType {
  /// 驾车
  driver,

  /// 步行
  walk,

  /// 公交
  bus,

  /// 骑行
  ride,

  /// 公交
  truck,

  /// 未来行
  plan,
}

class Geocode {
  final double latitude;

  final double longitude;

  final String formatted_address;

  final String province;

  final String adcode;

  final String city;

  final String district;

  Geocode({
    this.latitude,
    this.longitude,
    this.formatted_address,
    this.province,
    this.adcode,
    this.city,
    this.district,
  });

  factory Geocode.fromJson(Map<dynamic, dynamic> json) => _$GeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$GeocodeToJson(this);
}

Geocode _$GeocodeFromJson(Map<dynamic, dynamic> json) {
  return Geocode(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    formatted_address: json['address'] as String,
    city: json['city'] as String,
    province: json['province'] as String,
    district: json['district'] as String,
    adcode: json['adcode'] as String,
  );
}

Map<String, dynamic> _$GeocodeToJson(Geocode instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'formatted_address': instance.formatted_address,
      'adcode': instance.adcode,
      'city': instance.city,
      'province': instance.province,
      'district': instance.district,
    };
