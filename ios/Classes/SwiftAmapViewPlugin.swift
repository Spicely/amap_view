import Flutter
import AMapFoundationKit

public class SwiftAmapViewPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
       let resourceFileDictionary = NSDictionary(contentsOfFile: path)
       if let key = resourceFileDictionary?.object(forKey: "amap_key") {
           AMapServices.shared().apiKey = key as? String
       }
    }
   
    AMapServices.shared().enableHTTPS = true
    
    let channel = FlutterMethodChannel(name: "amap_view", binaryMessenger: registrar.messenger())
    let instance = AmapViewFactory(withMessenger: registrar.messenger())
    registrar.register(instance, withId: "plugins.muka.com/amap_view")
  }
}
