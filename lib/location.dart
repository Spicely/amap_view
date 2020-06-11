part of amap_location;

class Location {
  final double latitude;

  final double longitude;

  final String address;

  final String country;

  final String city;

  final String street;

  final String district;

  final double accuracy;

  final LocationGeocode geocode;

  Location({
    this.latitude,
    this.longitude,
    this.accuracy,
    this.address,
    this.city,
    this.country,
    this.district,
    this.street,
    this.geocode,
  });

  factory Location.fromJson(Map<dynamic, dynamic> json) => _$LocationFromJson(json);

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
    geocode: json['geocode'] == null ? null : LocationGeocode.fromJson(json['geocode'] as Map<dynamic, dynamic>),
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
      'geocode': instance.geocode,
    };

class LocationGeocode {
  final String towncode;

  final String township;

  final String adCode;

  final String cityCode;

  final String country;

  final String formatAddress;

  final String province;

  LocationGeocode({
    this.adCode,
    this.cityCode,
    this.country,
    this.formatAddress,
    this.province,
    this.towncode,
    this.township,
  });

  factory LocationGeocode.fromJson(Map<dynamic, dynamic> json) => _$LocationGeocodeFromJson(json);

  Map<String, dynamic> toJson() => _$LocationGeocodeToJson(this);
}

LocationGeocode _$LocationGeocodeFromJson(Map<dynamic, dynamic> json) {
  return LocationGeocode(
    adCode: json['adCode'] as String,
    cityCode: json['cityCode'] as String,
    country: json['country'] as String,
    formatAddress: json['formatAddress'] as String,
    province: json['province'] as String,
    towncode: json['towncode'] as String,
    township: json['township'] as String,
  );
}

Map<String, dynamic> _$LocationGeocodeToJson(LocationGeocode instance) => <String, dynamic>{
      'adCode': instance.adCode,
      'cityCode': instance.cityCode,
      'country': instance.country,
      'formatAddress': instance.formatAddress,
      'province': instance.province,
      'towncode': instance.towncode,
      'township': instance.township,
    };
