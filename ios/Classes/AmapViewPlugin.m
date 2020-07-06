#import "AmapViewPlugin.h"
#if __has_include(<amap_view/amap_view-Swift.h>)
#import <amap_view/amap_view-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_view-Swift.h"
#endif

@implementation AmapViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapViewPlugin registerWithRegistrar:registrar];
}
@end
