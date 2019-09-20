//
//  QRCaptureView.m
//  Runner
//
//  Created by cdx on 2019/8/2.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import "QRCaptureView.h"
#import <AVFoundation/AVFoundation.h>

@interface QRCaptureView ()<AVCaptureMetadataOutputObjectsDelegate, FlutterPlugin>
    
@property(nonatomic, strong) AVCaptureSession *session;

@property(nonatomic, strong) FlutterMethodChannel *channel;

@property(nonatomic, strong) UIView *captureView;

@end

@implementation QRCaptureView

- (AVCaptureSession *)session {
    if (!_session) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}

- (UIView *)captureView {
    if (!_captureView) {
        
    }
    return _captureView;
}

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (self = [super init]) {
        NSString *name = [NSString stringWithFormat:@"plugins/qr_capture/method_%lld", viewId];
        FlutterMethodChannel *channel = [FlutterMethodChannel
                                         methodChannelWithName:name
                                         binaryMessenger:registrar.messenger];
        self.channel = channel;
        [registrar addMethodCallDelegate:self channel:channel];
        
        UIView *captureView = [[UIView alloc] init];
        self.captureView = captureView;
        captureView.frame = [UIScreen mainScreen].bounds;
        
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        AVCaptureDeviceInput *input = [[AVCaptureDeviceInput alloc] initWithDevice:device error:nil];
        AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
        [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
        [self.session addInput:input];
        [self.session addOutput:output];
        self.session.sessionPreset = AVCaptureSessionPresetHigh;
        output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];
        AVCaptureVideoPreviewLayer *layer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
        [captureView.layer addSublayer:layer];
        layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        layer.frame = captureView.bounds;
        
        [self.session startRunning];
    }
    return self;
}

- (nonnull UIView *)view {
    return self.captureView;
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
