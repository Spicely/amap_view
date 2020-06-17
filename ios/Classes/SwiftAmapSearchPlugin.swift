import Flutter
import AMapFoundationKit

public class SwiftAmapSearchPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    
    if let path = Bundle.main.path(forResource: "Info", ofType: "plist") {
        let resourceFileDictionary = NSDictionary(contentsOfFile: path)
        if let key = resourceFileDictionary?.object(forKey: "amap_key") {
            AMapServices.shared().apiKey = key as? String
        }
    }
    
    AMapServices.shared().enableHTTPS = true
    
    AmapSearchFactory(withMessenger: registrar.messenger()).register()
  }
}
