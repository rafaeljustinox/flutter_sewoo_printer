import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sewoo_printer/sewoo_printer.dart';

void main() {
  const MethodChannel channel = MethodChannel('sewoo_printer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await SewooPrinter.platformVersion, '42');
  });
}
