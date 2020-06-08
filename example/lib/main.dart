import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amap_search/amap_search.dart';

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
            child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('坐标转换'),
              onPressed: () async {
                LatLng pos = await AmapUtils.convert(LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
                print(pos);
              },
            ),
            RaisedButton(
              child: Text('面积'),
              onPressed: () async {
                double area = await AmapUtils.calculateArea(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
                print(area);
              },
            ),
            RaisedButton(
              child: Text('直线距离'),
              onPressed: () async {
                double distance = await AmapUtils.calculateLineDistance(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
                print(distance);
              },
            ),
          ],
        )),
      ),
    );
  }
}
