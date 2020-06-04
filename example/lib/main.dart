import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

import 'package:amap_view/amap_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location _location;

  AMapController mapController;
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
  Map<PolylineId, Polyline> polylines = <PolylineId, Polyline>{

  };
  int _markerIdCounter = 1;
  ImageConfiguration imageConfiguration;
  LatLng center = LatLng(30.337875, 120.111339);
  MarkerId centerMarkerId = MarkerId("marker_center");

  @override
  void initState() {
    super.initState();
    imageConfiguration = createLocalImageConfiguration(context);
    setState(() {
      markers[centerMarkerId] = Marker(markerId: centerMarkerId, position: center, infoWindow: InfoWindow(title: "中心"));
    });

    initPlatformState();
  }

  Future<void> initPlatformState() async {
    Location location = await AmapLocation.fetchLocation();
    setState(() {
      _location = location;
    });
  }

  void _addMarker() async {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    var markerIcon = await BitmapDescriptor.fromAssetImageWithText(
      imageConfiguration,
      "assets/map-point.png",
      Label(text: "$_markerIdCounter", size: 48, color: Colors.red, offset: Offset(-1, 10)),
    );
    print(markerIcon.toMap());
    setState(() {
      markers[markerId] = Marker(
          markerId: markerId,
          icon: markerIcon,
          position:
              LatLng(center.latitude + sin(_markerIdCounter * pi / 6.0) / 20.0, center.longitude + sin(_markerIdCounter * pi / 6.0) / 20.0),
          infoWindow: InfoWindow(title: 'test', snippet: "hahahkwg"));
    });
  }

  void _addPolyline() async {
    final PolylineId polylineId = PolylineId('polyline_01');
    setState(() {
      polylines[polylineId] =
          Polyline(polylineId: polylineId, points: <LatLng>[LatLng(30.69674, 104.074232), LatLng(30.666328, 104.065821)]);
    });
  }

  void _clear() {
    setState(() {
      markers = {};
      polylines = {};
    });
  }

  Future<void> _searchRoute(LatLng start, LatLng end) async {
    var result = await AmapSearch.route(
      start: start,
      end: end,
    );
    // print(result);
    var routes = result[0]["steps"].map((i) => i["polyline"].map((p) => LatLng(p["latitude"], p["longitude"])).toList()).toList();
    setState(() {
      polylines = {};
      for (var i = 0; i < routes.length; i++) {
        var polylineId = PolylineId('polyline_$i');
        polylines[polylineId] = Polyline(
          polylineId: polylineId,
          width: 20,
          points: List<LatLng>.from(routes[i]),
        );
      }
    });
  }

  // Future<void> cameraMove(LatLng loc) async {
  //   await mapController.animateCamera(CameraUpdate.newLatLng(loc));
  // }

  // Future<dynamic> inputTips(String keyword, String city) async {
  //   var result = await AmapSearch.inputTips(keyword, city);
  //   print("inputTips-> $result");
  //   return result;
  // }

  void _onMapCreated(AMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: <Widget>[
            SizedBox(
              width: double.infinity,
              height: 500,
              child: AmapView(
                initialCameraPosition: CameraPosition(target: LatLng(30.688695, 104.077751), zoom: 13),
                // myLocationEnabled: true,
                scaleControlsEnabled: false,
                markers: Set<Marker>.of(markers.values),
                polylines: Set<Polyline>.of(polylines.values),
                setMyLocationButtonEnabled: true,
                onCameraMove: (pos) {
                  print("onCameraMove ${pos.target}");
                  setState(() {
                    markers[centerMarkerId] = markers[centerMarkerId].copyWith(positionParam: pos.target);
                  });
                },
                onCameraIdle: (pos) {
                  //var result = await mapController.reGeocodeSearch(ReGeocodeParams(point: pos.target));
                  //print("onCameraIdle reGeocodeSearch: $result");
                  print("onCameraIdle =====> $pos");
                },
                onTap: (pos) {
                  print("onTap====> $pos");
                },
                onMapCreated: _onMapCreated,
              ),
            ),
            Text("当前位置: ${_location?.address}"),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("添加"),
                  onPressed: () {
                    _addMarker();
                  },
                ),
                RaisedButton(
                  child: Text("定位"),
                  onPressed: () async {
                    Location location = await AmapLocation.fetchLocation();
                    print(location.toJson());
                  },
                ),
                RaisedButton(
                  child: Text("导航"),
                  onPressed: () async {
                    await AmapNavi.showRoute(
                      naviType: NaviType.ride,
                      // start: Poi("", LatLng(30.649863, 104.066851), ""),
                      end: Poi("下一站", LatLng(30.659019, 104.057066), ""),
                    );
                  },
                ),
                RaisedButton(
                  child: Text("路径规划"),
                  onPressed: () async {
                    dynamic data = await AmapSearch.route(
                      start: LatLng(30.649863, 104.066851),
                      end: LatLng(30.659019, 104.057066),
                      routeType: RouteType.ride,
                    );
                    print(data);
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("距离测量"),
                  onPressed: () async {
                    double distance = await AmapUtils.calculateLineDistance(LatLng(30.649863, 104.066851), LatLng(30.659019, 104.057066));
                    print(distance);
                  },
                ),
                RaisedButton(
                  child: Text("面积计算"),
                  onPressed: () async {
                    double distance = await AmapUtils.calculateArea(LatLng(30.765133, 103.955872), LatLng(30.608061, 104.138519));
                    print(distance);
                  },
                ),
                RaisedButton(
                  child: Text("坐标转换"),
                  onPressed: () async {
                    LatLng latLng = await AmapUtils.converter(LatLng(39.93917, 116.379547), CoordType.baidu);
                    print(latLng);
                  },
                ),
                RaisedButton(
                  child: Text("地址转坐标"),
                  onPressed: () async {
                    List<Geocode> result = await AmapSearch.geocode('北京市海淀区北京大学口腔医院');
                    result.forEach((e) {
                       print(e.toJson());
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                RaisedButton(
                  child: Text("坐标转地址"),
                  onPressed: () async {
                    dynamic res = await AmapSearch.reGeocode(LatLng(30.649863, 104.066851),latLntType: LatLntType.amap, radius: 200);
                    print(res);
                  },
                ),
                RaisedButton(
                  child: Text("添加折线"),
                  onPressed: _addPolyline,
                ),
                // RaisedButton(
                //   child: Text("坐标转换"),
                //   onPressed: () async {
                //     LatLng latLng = await AmapUtils.converter(LatLng(39.93917, 116.379547), CoordType.baidu);
                //     print(latLng);
                //   },
                // ),
                // RaisedButton(
                //   child: Text("地址转坐标"),
                //   onPressed: () async {
                //     List<Geocode> result = await AmapSearch.geocode('北京市海淀区北京大学口腔医院');
                //     result.forEach((e) {
                //        print(e.toJson());
                //     });
                //   },
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
