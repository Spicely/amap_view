# amap_search_muka

Flutter amap_search_muka

## 引入

```
    amap_search:
        git: https://github.com/Spicely/amap_view.git
        ref: 'amap_search_muka'
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
    /// 坐标转换 [仅Andorid可用]
    LatLng pos = await AmapUtils.convert(LatLng(40.012044, 116.332404), type: ConvertType.BAIDU);
    print(pos);

    /// 直线距离
    double distance = await AmapUtils.calculateLineDistance(LatLng(30.766903, 103.955872), LatLng(30.577889, 104.169418));
    print(distance);

    /// 获取POI
    List<SearchPoi> pois = await AmapSearch.poiKeywordsSearch('火车站', city: '成都');
    print(pois.toList());

    /// 获取输入提示
    List<InputTip> pois = await AmapSearch.inputTipsSearch('火车');
    pois.forEach((element) {
        print(element.toJson());
    });
```