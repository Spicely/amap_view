import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_navi/amap_navi.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: RaisedButton(
            child: Text("导航"),
            onPressed: () async {
              if (await Permission.locationAlways.request().isGranted) {
                await AmapNavi.showRoute(
                  naviType: NaviType.WALK,
                  // start: Poi("", LatLng(30.649863, 104.066851), ""),
                  end: Poi("下一站", LatLng(30.659019, 104.057066), ""),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
