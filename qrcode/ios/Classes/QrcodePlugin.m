#import "QrcodePlugin.h"
#import "QRCaptureViewFactory.h"

@implementation QrcodePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    QRCaptureViewFactory *factory = [[QRCaptureViewFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:factory withId:@"plugins/qr_capture_view"];
}

@end
