import Flutter
import AMapFoundationKit

public class SwiftAmapViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    //Load content of Info.plist into resourceFileDictionary dictionary
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
        let resourceFileDictionary = NSDictionary(contentsOfFile: path)
        if let key = resourceFileDictionary?.object(forKey: "amap_key") {
            AMapServices.shared().apiKey = key as? String
        }
    }
    
    AMapServices.shared().enableHTTPS = true

    let instance = AmapViewFactory(withMessenger: registrar.messenger())
    registrar.register(instance, withId: "plugins.laoqiu.com/amap_view")
    
    // 其他组件初始化
    AmapLocationFactory(withMessenger: registrar.messenger()).register()
    AmapNavFactory(withMessenger: registrar.messenger()).register()
    AmapSearchFactory(withMessenger: registrar.messenger()).register()
  }
}
