import 'package:flutter/material.dart';
import 'dart:async';

import 'package:permission_handler/permission_handler.dart';
import 'package:amap_location/amap_location.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Location _location;
  Function stopLocation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds: 100), () {
      initPlatformState();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
        break;
      case AppLifecycleState.resumed: // 应用程序可见，前台
      print('22111112122');
        await AmapLocation.disableBackground();
        break;
      case AppLifecycleState.paused: // 应用程序不可见，后台
        print('22222222');
        await AmapLocation.enableBackground(assetName: 'app_icon', label: '正在获取位置信息', title: '高德地图', vibrate: false);
        break;
      default:
        break;
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    await [Permission.locationAlways, Permission.locationWhenInUse, Permission.location].request();
    print('单次定位');
    _location = await AmapLocation.fetch();
    print(_location.toJson());
    print('单次定位');
    setState(() {});
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
              child: Text('Running on: ${_location?.address}'),
            ),
            RaisedButton(
              child: Text('停止定位'),
              onPressed: () async {
                if (stopLocation != null) {
                  await stopLocation();
                  print('停止定位');
                }
              },
            ),
            RaisedButton(
              child: Text('单次定位'),
              onPressed: () async {
                _location = await AmapLocation.fetch();
                print(_location.toJson());
                print('单次定位');
                setState(() {});
              },
            ),
            RaisedButton(
              child: Text('持续定位'),
              onPressed: () async {
                print('持续定位');
                stopLocation = await AmapLocation.start(
                  time: 10000,
                  listen: (Location location) {
                    print(location.toJson());
                    print('持续定位222');
                  },
                );
              },
            ),
            // RaisedButton(
            //   child: Text('地址转换'),
            //   onPressed: () async {
            //     // LatLng pos = await AmapLocation.convert(latLng: LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
            //     // print(pos);
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
