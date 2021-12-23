import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

typedef CaptureCallback(String data);

class QRCaptureController {
  late MethodChannel _methodChannel;
  CaptureCallback? _capture;

  QRCaptureController();

  void _onPlatformViewCreated(int id) {
    _methodChannel = MethodChannel('plugins/qr_capture/method_$id');
    _methodChannel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onCaptured') {
        if (_capture != null && call.arguments != null) {
          _capture!(call.arguments.toString());
        }
      }
    });
  }

  void pause() {
    _methodChannel.invokeMethod('pause');
  }

  void resume() {
    _methodChannel.invokeMethod('resume');
  }

  void onCapture(CaptureCallback capture) {
    _capture = capture;
  }
}

class QRCaptureView extends StatefulWidget {
  final QRCaptureController controller;
  QRCaptureView({Key? key, required this.controller}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QRCaptureViewState();
  }
}

class QRCaptureViewState extends State<QRCaptureView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return UiKitView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller._onPlatformViewCreated(id);
        },
      );
    } else {
      return AndroidView(
        viewType: 'plugins/qr_capture_view',
        creationParamsCodec: StandardMessageCodec(),
        onPlatformViewCreated: (id) {
          widget.controller._onPlatformViewCreated(id);
        },
      );
    }
  }
}
