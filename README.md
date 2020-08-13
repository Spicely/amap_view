# amap_location

Flutter高德定位插件

## 引入方式

```
    amap_location:
      git:
        url: https://github.com/Spicely/amap_view.git
        ref: location
```

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
    <string>你的key</string>

    // 导航 后台持续定位只需要location
    <key>UIBackgroundModes</key> 
    <array> 
        <string>location</string>
        <string>audio</string> 
    </array>
```

#### AmapLocation

```
    /// 持续定位 IOS目前有问题
    stopLocation = await AmapLocation.start(
        listen: (Location location) {
            print(location.toJson());
        },
    );
    
    /// 停止定位
    stopLocation();

    /// 单次定位 可传递geocode参数获取逆地理编码
    Location location = await AmapLocation.fetch();
    print(location.toJson());

    /// 后台定位 IOS目前有问题
    /// vibrate 属性只支持一次性设置 设置后除非卸载app否则不会变更
    /// 另一种办法是变更chanlid 但对于定位来说 一般不会变更 暂时不考虑提供参数
    class _MyAppState extends State<MyApp> with WidgetsBindingObserver {

        @override
        void initState() {
            super.initState();
            WidgetsBinding.instance.addObserver(this);
        }

        @override
        void didChangeAppLifecycleState(AppLifecycleState state) async {
            switch (state) {
            case AppLifecycleState.inactive: // 处于这种状态的应用程序应该假设它们可能在任何时候暂停。
                break;
            case AppLifecycleState.resumed: // 应用程序可见，前台
                await AmapLocation.disableBackground();
                break;
            case AppLifecycleState.paused: // 应用程序不可见，后台
                await AmapLocation.enableBackground(assetName: 'app_icon', label: '正在获取位置信息', title: '高德地图',vibrate: false);
                break;
            default:
                break;
            }
        }
    }
```