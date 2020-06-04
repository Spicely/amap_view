#import "AmapLocationPlugin.h"
#if __has_include(<amap_location/amap_location-Swift.h>)
#import <amap_location/amap_location-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_location-Swift.h"
#endif

@implementation AmapLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapLocationPlugin registerWithRegistrar:registrar];
}
@end
