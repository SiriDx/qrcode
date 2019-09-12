# qrcode
A flutter plugin for scanning QR codes. Use AVCaptureSession in iOS and zxing in Android.

![image](https://github.com/SiriDx/qrcode/blob/master/res/demo.PNG=375x667)

## Usage

```dart
class _DemoState extends State<Demo> {
  QRCaptureController _captureController = QRCaptureController();

  @override
  void initState() {
    super.initState();
    _captureController.onCapture((data) {
      print('onCapture----$data');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        floatingActionButton: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            FlatButton(
              onPressed: () {
                _captureController.pause();
              },
              child: Text('pause'),
            ),
            FlatButton(
              onPressed: () {
                _captureController.resume();
              },
              child: Text('resume'),
            ),
          ],
        ),
        body: QRCaptureView(
          controller: _captureController,
        ),
      ),
    );
  }
}
```

## Integration

### iOS
To use on iOS, you must add the following to your Info.plist


```
<key>NSCameraUsageDescription</key>
<string>Camera permission is required for barcode scanning.</string>
<key>io.flutter.embedded_views_preview</key>
<true/>
```
