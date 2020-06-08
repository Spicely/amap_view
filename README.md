# amap_utils

Flutter amap_search

## 引入

```
    amap_search:
        git: https://github.com/Spicely/amap_view.git
        ref: 'amap_search'
```

## Android

在`AndroidManifest.xml`添加如下代码
`
 <meta-data android:name="com.amap.api.v2.apikey" android:value="你的key" />
`

## IOS

在`Info.plist`添加如下代码

```
    <key>amap_key</key>
    <string>你的key</string>
```

### 示例
```
    /// 坐标转换
    LatLng pos = await AmapUtils.convert(LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
    print(pos);

    /// 面积
    double area = await AmapUtils.calculateArea(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
    print(area);

    /// 直线距离
    double distance = await AmapUtils.calculateLineDistance(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
    print(distance);
```