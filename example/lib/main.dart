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
  @override
  void initState() {
    super.initState();
    _loca();
    setState(() {
      markers[centerMarkerId] = Marker(
        markerId: centerMarkerId,
        position: LatLng(30.654889, 104.081402),
        infoWindow: InfoWindow(title: "中心"),
      );
    });
  }

  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};

  MarkerId centerMarkerId = MarkerId("marker_center");

  LatLng center = LatLng(30.654889, 104.081402);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: AmapView(
          initialCameraPosition: CameraPosition(
            target: center,
            zoom: 17,
            tilt: 170,
          ),
          markers: Set<Marker>.of(markers.values),
          onCameraIdle: (CameraPosition position) {
            setState(() {
              center = position.target;
              markers[centerMarkerId] = Marker(
                markerId: centerMarkerId,
                position: position.target,
                infoWindowEnable: true,
                draggable: true,
              );
            });
          },
        ),
      ),
    );
  }

  void _loca() async {
    if (await Permission.location.request().isGranted) {}
  }
}
