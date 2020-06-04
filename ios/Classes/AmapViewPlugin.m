#import "AmapViewPlugin.h"
#import <amap_view/amap_view-Swift.h>

@implementation AmapViewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmapViewPlugin registerWithRegistrar:registrar];
}
@end
