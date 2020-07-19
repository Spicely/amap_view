import 'dart:math';

import 'package:flutter/material.dart';

import 'package:amap_view/amap_view.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _markerIdCounter = 1;
  ImageConfiguration imageConfiguration;

  @override
  void initState() {
    super.initState();
    imageConfiguration = createLocalImageConfiguration(context);

    _loca();
    _getMap();
  }

  _getMap() async {
    var markerIcon = await BitmapDescriptor.fromAssetImageWithText(
      imageConfiguration,
      "assets/images/map.png",
      Label(text: "测试", size: 11, color: Colors.red, offset: Offset(-1, 10)),
    );
    setState(() {
      markers[centerMarkerId] = Marker(
        markerId: centerMarkerId,
        position: LatLng(30.654889, 104.081402),
        infoWindow: InfoWindow(title: "中心"),
        icon: markerIcon,
      );
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MarkerId centerMarkerId = MarkerId("marker_0");

  LatLng center = LatLng(30.654889, 104.081402);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: AmapView(
                initialCameraPosition: CameraPosition(
                  target: center,
                  zoom: 17,
                  tilt: 170,
                ),
                // myLocationEnabled: true,
                // myLocationStyle: MyLocationStyle.LOCATION_TYPE_FOLLOW,
                markers: Set<Marker>.of(markers.values),
                // onCameraIdle: (CameraPosition position) {
                //   setState(() {
                //     center = position.target;
                //     markers[centerMarkerId] = Marker(
                //       markerId: centerMarkerId,
                //       position: position.target,
                //       infoWindowEnable: true,
                //       draggable: true,
                //     );
                //   });
                // },
              ),
            ),
            Row(
              children: <Widget>[
                RaisedButton(
                  child: Text("添加Marker"),
                  onPressed: _addMarker,
                ),
                RaisedButton(
                  child: Text("删除Marker"),
                  onPressed: () {
                    setState(() {
                      markers.clear();
                    });
                  },
                ),
                RaisedButton(
                  child: Text("单个删除"),
                  onPressed: () {
                    setState(() {
                      markers.remove(centerMarkerId);
                    });
                  },
                ),
                RaisedButton(
                  child: Text("更新"),
                  onPressed: () {
                    setState(() {
                      markers.update(centerMarkerId,(Marker marker) {
                        return marker.copyWith(showInfoWindow: true, infoWindowParam: InfoWindow(title:"3322",snippet: "333"));
                      });
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _loca() async {
    if (await Permission.locationWhenInUse.request().isGranted) {}
  }

  void _addMarker() async {
    final String markerIdVal = 'marker_$_markerIdCounter';
    _markerIdCounter++;
    final MarkerId markerId = MarkerId(markerIdVal);
    var markerIcon = await BitmapDescriptor.fromAssetImageWithText(
      imageConfiguration,
      "assets/images/map.png",
      Label(text: "$_markerIdCounter", size: 48, color: Colors.red, offset: Offset(-1, 10)),
    );
    print(markerIcon.toMap());
    setState(() {
      markers[markerId] = Marker(
        markerId: markerId,
        icon: markerIcon,
        showInfoWindow: true,
        position: LatLng(
            center.latitude + sin(_markerIdCounter * pi / 6.0) / 2000.0, center.longitude + sin(_markerIdCounter * pi / 6.0) / 2000.0),
        infoWindow: InfoWindow(
          title: 'test$_markerIdCounter',
          snippet: "hahahkwg",
          onTap: () {
            print('111');
          },
        ),
      );
    });
  }
}
