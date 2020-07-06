//
//  AmapViewFactory.swift
//  amap_view
//
//  Created by Spicely on 2020/7/6.
//


class AmapViewFactory: NSObject, FlutterPlatformViewFactory {
    var messenger: FlutterBinaryMessenger
    
    func create(withFrame frame: CGRect, viewIdentifier viewId: Int64, arguments args: Any?) -> FlutterPlatformView {
        return AmapViewController(withFrame: frame, viewIdentifier: viewId, arguments: args, binaryMessenger: messenger)
    }
    
    init(withMessenger messenger: FlutterBinaryMessenger) {
        self.messenger = messenger
        super.init()
    }
    
    func createArgsCodec() -> FlutterMessageCodec & NSObjectProtocol {
        return FlutterStandardMessageCodec.sharedInstance()
    }
}
