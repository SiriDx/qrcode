//
//  QRCaptureView.m
//  Pods-Runner
//
//  Created by cdx on 2019/10/28.
//

#import "QRCaptureView.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCaptureView () <AVCaptureMetadataOutputObjectsDelegate, FlutterPlugin>

@property(nonatomic, strong) AVCaptureSession *session;
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic, weak) AVCaptureVideoPreviewLayer *captureLayer;

@end

@implementation QRCaptureView

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (self = [super initWithFrame:frame]) {
        NSString *name = [NSString stringWithFormat:@"plugins/qr_capture/method_%lld", viewId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                         methodChannelWithName:name
                                         binaryMessenger:registrar.messenger];
        self.channel = channel;
        [registrar addMethodCallDelegate:self channel:channel];
        
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(status == AVAuthorizationStatusAuthorized || status == AVAuthorizationStatusNotDetermined) {
            
            AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.captureLayer = layer;
            
            layer.backgroundColor = [UIColor blackColor].CGColor;
            [self.layer addSublayer:layer];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
            AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
            [self.session addInput:input];
            [self.session addOutput:output];
            self.session.sessionPreset = AVCaptureSessionPresetHigh;
            
            output.metadataObjectTypes = output.availableMetadataObjectTypes;
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            [output setMetadataObjectTypes:@[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode]];
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [self.session startRunning];
             });

        } else { 

            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Tips" message:@"Authorization is required to use the camera, please check your permission settings: Settings> Privacy> Camera" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                [alert show];
        }
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.captureLayer.frame = self.bounds;
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"pause"]) {
        [self pause];
    } else if ([call.method isEqualToString:@"resume"]) {
        [self resume];
    } else if ([call.method isEqualToString:@"setTorchMode"]) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (!device.hasTorch) {
            return;
        }
        NSNumber *isOn = call.arguments;
        [device lockForConfiguration:nil];
        if (isOn.boolValue) {
            [device setTorchMode:AVCaptureTorchModeOn];
        } else {
            [device setTorchMode:AVCaptureTorchModeOff];
        }
        [device unlockForConfiguration];
    }
}

+ (void)registerWithRegistrar:(nonnull NSObject<FlutterPluginRegistrar> *)registrar {}


- (void)resume {
    [self.session startRunning];
}

- (void)pause {
    [self.session stopRunning];
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
-(void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (metadataObjects.count>0) {
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *value = metadataObject.stringValue;
        if (value.length && self.channel) {
            [self.channel invokeMethod:@"onCaptured" arguments:value];
        }
    }
}

- (void)dealloc {
    [self.session stopRunning];
}

@end
