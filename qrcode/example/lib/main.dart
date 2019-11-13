import 'package:flutter/material.dart';
import 'package:qrcode/qrcode.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  QRCaptureController _captureController = QRCaptureController();
  Animation<Alignment> _animation;
  AnimationController _animationController;

  bool _isTorchOn = false;

  String _captureText = '';

  @override
  void initState() {
    super.initState();

    _captureController.onCapture((data) {
      print('onCapture----$data');
      setState(() {
        _captureText = data;
      });
    });

    _animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animation =
        AlignmentTween(begin: Alignment.topCenter, end: Alignment.bottomCenter)
            .animate(_animationController)
              ..addListener(() {
                setState(() {});
              })
              ..addStatusListener((status) {
                if (status == AnimationStatus.completed) {
                  _animationController.reverse();
                } else if (status == AnimationStatus.dismissed) {
                  _animationController.forward();
                }
              });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('扫一扫'),
        ),
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 250,
              height: 250,
              child: QRCaptureView(
              controller: _captureController,
            ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 56),
              child: AspectRatio(
                aspectRatio: 264 / 258.0,
                child: Stack(
                  alignment: _animation.value,
                  children: <Widget>[
                    Image.asset('images/sao@3x.png'),
                    Image.asset('images/tiao@3x.png')
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildToolBar(),
            ),
            Container(
              child: Text('$_captureText'),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildToolBar() {
    return Row(
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
                if (_isTorchOn) {
                  _captureController.torchMode = CaptureTorchMode.off;
                } else {
                  _captureController.torchMode = CaptureTorchMode.on;
                }
                _isTorchOn = !_isTorchOn;
              },
              child: Text('torch'),
            ),
            FlatButton(
              onPressed: () {
                _captureController.resume();
              },
              child: Text('resume'),
            ),
          ],
        );
  }
}
