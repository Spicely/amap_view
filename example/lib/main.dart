import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Location location;
  Function stopLocation;

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (await Permission.locationAlways.request().isGranted) {
      location = await AmapLocation.fetch();
      print(location.toJson());
      print('单次定位');

      setState(() {});
    }
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
            Center(
              child: Text('Running on: ${location?.address}'),
            ),
            RaisedButton(
              child: Text('停止定位'),
              onPressed: () async {
                print('停止定位');
                if (stopLocation != null) {
                  stopLocation();
                }
              },
            ),
            RaisedButton(
              child: Text('单次定位'),
              onPressed: () async {
                location = await AmapLocation.fetch();
                print(location.toJson());
                print('单次定位');
              },
            ),
            RaisedButton(
              child: Text('持续定位'),
              onPressed: () async {
                stopLocation = await AmapLocation.start(
                  listen: (Location location) {
                    print(location.toJson());
                    print('持续定位');
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
