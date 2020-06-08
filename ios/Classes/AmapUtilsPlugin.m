#import "AmapUtilsPlugin.h"
#if __has_include(<amap_utils/amap_utils-Swift.h>)
#import <amap_utils/amap_utils-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amap_utils-Swift.h"
#endif

@implementation AmapUtilsPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapUtilsPlugin registerWithRegistrar:registrar];
}
@end
