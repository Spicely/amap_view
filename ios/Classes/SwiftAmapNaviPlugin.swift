import Flutter
import UIKit

public class SwiftAmapNaviPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    AmapNavFactory(withMessenger: registrar.messenger()).register()
  }
}
