// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:qrcode/qrcode.dart';

import 'package:qrcode_example/main.dart';

void main() {
  testWidgets('has QR view', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.byType(QRCaptureView), findsOneWidget);
  });

  testWidgets('has buttons', (WidgetTester tester) async {
    await tester.pumpWidget(MyApp());

    expect(find.text('pause'), findsOneWidget);
    expect(find.text('resume'), findsOneWidget);
  });
}
