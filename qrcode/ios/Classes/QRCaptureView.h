//
//  QRCaptureView.h
//  Runner
//
//  Created by cdx on 2019/8/2.
//  Copyright © 2019 The Chromium Authors. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCaptureView : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame viewIdentifier:(int64_t)viewId arguments:(id _Nullable)args registrar:(NSObject<FlutterPluginRegistrar>*)registrar;


@end

NS_ASSUME_NONNULL_END
