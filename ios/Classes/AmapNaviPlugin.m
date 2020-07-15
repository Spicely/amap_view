#import "AmapNaviPlugin.h"
#if __has_include(<amap_navi/amap_navi-Swift.h>)
#import <amap_navi/amap_navi-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_navi-Swift.h"
#endif

@implementation AmapNaviPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapNaviPlugin registerWithRegistrar:registrar];
}
@end
