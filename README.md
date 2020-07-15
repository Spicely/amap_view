# amap_navi

高德地图 导航插件

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
    <key>io.flutter.embedded_views_preview</key>
	<true/>
    <key>amap_key</key>
    <string>  你的key  </string>

    // 导航
    <key>UIBackgroundModes</key> 
    <array> 
        <string>location</string>
        <string>audio</string> 
    </array>
```

`IOS中 骑行、步行使用默认样式`

```
    await AmapNavi.showRoute(
        // DRIVER 汽车导航 默认使用官方组件 RIDE 骑行 WALK 步行 【骑行和步行为自定义SDK 发起直接进入导航】
        naviType: NaviType.DRIVER, 
        end: Poi("下一站", LatLng(30.659314, 104.056294), ""),
    );
```