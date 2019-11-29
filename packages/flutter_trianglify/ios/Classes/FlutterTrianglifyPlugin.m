#import "FlutterTrianglifyPlugin.h"
#import <flutter_trianglify/flutter_trianglify-Swift.h>

@implementation FlutterTrianglifyPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterTrianglifyPlugin registerWithRegistrar:registrar];
}
@end
