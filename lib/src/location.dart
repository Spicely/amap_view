part of amap_view;

class AmapLocation {
  static const _channel =
      MethodChannel('plugins.laoqiu.com/amap_view_location');
  static const _event =
      EventChannel('plugins.laoqiu.com/amap_view_location_event');

  static Future<void> start({int interval}) async {
    await _channel.invokeMethod('location#start', {"interval": interval});
  }

  static Future<Location> fetchLocation() async {
    dynamic location = await _channel.invokeMethod('location#fetchLocation');
    return Location.fromJson(location);
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('location#stop');
  }

  static Future<dynamic> convert(ConvertParms params) async {
    return await _channel.invokeMethod('location#convert', params.toMap());
  }

  static void listen(Function callback) {
    _event.receiveBroadcastStream().listen(callback);
  }
}

class LatLng {
  const LatLng(this.latitude, this.longitude)
      : assert(latitude != null),
        assert(longitude != null);

  final double latitude;
  final double longitude;

  Map<String, dynamic> toMap() {
    return {"latitude": latitude, "longitude": longitude};
  }

  static LatLng fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return LatLng(json["latitude"], json["longitude"]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}

class LatLngBounds {
  const LatLngBounds(this.southwest, this.northeast)
      : assert(southwest != null),
        assert(northeast != null);

  final LatLng southwest;
  final LatLng northeast;

  Map<String, dynamic> toMap() {
    return {"southwest": northeast.toMap(), "northeast": northeast.toMap()};
  }

//  static LatLngBounds fromJson(dynamic json) {
//    if (json == null) {
//      return null;
//    }
//    return LatLngBounds();
//  }

  @override
  String toString() => '$runtimeType($southwest, $northeast)';

  @override
  bool operator ==(Object o) {
    return o is LatLngBounds &&
        o.northeast == northeast &&
        o.southwest == southwest;
  }

  @override
  int get hashCode => hashValues(northeast, southwest);
}

class Poi {
  Poi(this.name, this.target, this.s1)
      : assert(name != null),
        assert(target != null);

  final String name;
  final LatLng target;
  final String s1;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent("name", name);
    addIfPresent("target", target.toMap());
    addIfPresent("s1", s1);

    return _data;
  }
}

class ConvertParms {
  ConvertParms({this.latitude, this.longitude, this.coordType = 0});

  final double latitude;
  final double longitude;
  final int coordType;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> _data = <String, dynamic>{};
    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        _data[fieldName] = value;
      }
    }

    addIfPresent("latitude", latitude);
    addIfPresent("longitude", longitude);
    addIfPresent("coordType", coordType);

    return _data;
  }
}

class Location {
  final double latitude;

  final double longitude;

  final String address;

  final String country;

  final String city;

  final String street;

  final String district;

  final double accuracy;

  Location({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.address,
    this.city,
    this.country,
    this.district,
    this.street,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) =>
      _$LocationFromJson(json);

  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

Location _$LocationFromJson(Map<dynamic, dynamic> json) {
  return Location(
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
    accuracy: json['accuracy'] as num,
    address: json['address'] as String,
    city: json['city'] as String,
    country: json['country'] as String,
    district: json['district'] as String,
    street: json['street'] as String,
  );
}

Map<String, dynamic> _$LocationToJson(Location instance) => <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'address': instance.address,
      'country': instance.country,
      'city': instance.city,
      'street': instance.street,
      'district': instance.district,
      'accuracy': instance.accuracy,
    };
