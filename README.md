# amap_view

高德地图 地图插件

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