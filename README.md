# amap_view

高德地图插件

## Android

在`AndroidManifest.xml`添加如下代码
`
 <meta-data android:name="com.amap.api.v2.apikey" android:value="你的key" />
`

## IOS

在`Info.plist`添加如下代码

```
    // 默认
    <key>NSLocationWhenInUseUsageDescription</key>
    <string>App需要您的同意,才能访问位置</string>
    <key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
    <string>App需要您的同意,才能访问位置</string>
    <key>amap_key</key>
    <string>  你的key  </string>

    // 导航
    <key>UIBackgroundModes</key> 
    <array> 
        <string>location</string>
        <string>audio</string> 
    </array>
```

#### AmapUtils`目前只支持Android`
```
    /// 直线距离测量
    double distance = await AmapUtils.calculateLineDistance(LatLng(30.649863, 104.066851), LatLng(30.659019, 104.057066));
    print(distance);

    /// 面积计算
    double distance = await AmapUtils.calculateArea(LatLng(30.765133, 103.955872), LatLng(30.608061, 104.138519));
    print(distance);

    /// 坐标转换
    LatLng latLng = await AmapUtils.converter(LatLng(39.93917, 116.379547), CoordType.baidu);
    print(latLng);
```

### AmapSearch
```
    /// 地理编码（地址转坐标）
    List<Geocode> result = await AmapSearch.geocode('北京市海淀区北京大学口腔医院');
    result.forEach((e) {
        print(e.toJson());
    });
```

#### AmapLocation

```
    /// 持续定位
    await AmapLocation.start();
    AmapLocation.listen((dynamic location) { print(location);});

    /// 单次定位
    Location location = await AmapLocation.fetchLocation();
    print(location.toJson());
```

#### AmapView

```
    AmapView(
        initialCameraPosition: CameraPosition(target: center, zoom: 13),
        myLocationEnabled: true,
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
            print("onCameraIdle =====> $pos");
        },
        onTap: (pos) {
            print("onTap====> $pos");
        },
        onMapCreated: (AMapController controller) {
            mapController = controller;
        },
    )
```

#### AmapNavi `IOS中 骑行、步行使用默认样式`

```
    await AmapNavi.showRoute(
        // driver 汽车导航 默认使用官方组件 ride 骑行 walk 步行 【骑行和步行为自定义SDK 发起直接进入导航】
        naviType: NaviType.driver, 
        end: Poi("下一站", LatLng(30.659314, 104.056294), ""),
    );
```