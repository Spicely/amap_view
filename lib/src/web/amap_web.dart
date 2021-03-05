@JS('AMap')
library amap_web;

import 'package:js/js.dart';

@JS('Map')
class AMap {
  external AMap(dynamic div, MapOptions opts);
  external plugin(dynamic name, void Function() callback);
  external addControl(dynamic name);
}

@JS()
@anonymous
class MapOptions {
  external LngLat get center;
  external set center(LngLat v);
  external factory MapOptions({
    LngLat center,
    num zoom,
    String viewMode,
  });
}

@JS()
@anonymous
class GeoOptions {
  external bool enableHighAccuracy;
  external int timeout;
  external String buttonPosition;
  external bool zoomToAccuracy;
}

@JS()
class Geolocation {
  external Geolocation(GeoOptions opts);
  external getCurrentPosition(void Function(String status, GeolocationResult result) callback);
  external getCityInfo(void Function(String status, dynamic result) callback);
}

@JS()
class GeolocationResult {
  external GeolocationResultPosition position;
  external GeolocationResultAddressComponent addressComponent;
  external String formattedAddress;
  external String message;
}

@JS()
class GeolocationResultAddressComponent {
  external String country;
  external String province;
  external String city;
  external String district;
  external String street;
}

@JS()
class GeolocationResultPosition {
  external double lat;
  external double lng;
}

@JS()
class LngLat {
  external num getLng();
  external num getLat();
  external LngLat(num lng, num lat);
}
