import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sewoo_printer/pricetag_layout.dart';
import 'package:sewoo_printer/pricetag_data.dart';
import 'package:sewoo_printer/printer_events.dart';
import 'package:image/image.dart' as im;
import 'package:printing/printing.dart' show Printing;
import 'package:sewoo_printer/sewoo_document.dart';

class SewooPrinter {

  static const MethodChannel _channel =
      const MethodChannel('sewoo_printer');

  static String? _status = '';
  static bool _connected = false;
  static num _printerDpi = 203.0;
  static Directory? _imgDir;

  static bool get connected => _connected;

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> connect(String ip, int port) async {
    if ( ip.isEmpty || port.isNegative ) {
      return false;
    } else {
      try {
        await _channel.invokeMethod('connect', <String, dynamic> {
          'ip': ip,
          'port': port
        });
        return true;
      } on PlatformException catch (e) {
        print(e);
        return false;
      }
    }
  }

  static Future<void> disconnect() async {
    try {
      await _channel.invokeMethod('disconnect');
    } on PlatformException catch (e) {
      print(e);
    }
  }

  static Future<String?> getStatus() async {
    String? status;
    try {
      final String? result = await _channel.invokeMethod('status');
      status = result;
      
    } on PlatformException catch (e) {
      status = 'Failed: ${e.message}';
    }

    _status = status;
    return _status;
  }

  static Future<bool> copyFile(String fileName) async {
    
    SewooPrinter._imgDir = await getExternalStorageDirectory();
    final String path = "${_imgDir!.path}/$fileName";
    
    final file = File(path);
    final ByteData data = await rootBundle.load('assets/$fileName');
    final Uint8List bytes = data.buffer.asUint8List();
    await file.writeAsBytes(bytes);
    return true;
  }

  static void listenEvents( Function callback ) {

    _channel.setMethodCallHandler((call) {
      switch (call.method) {
        case 'connect':
          SewooPrinter._connected = call.arguments ? true : false;
          PrinterEvent event = PrinterEvent(call.method, SewooPrinter._connected);
          callback( event );
          break;
        case 'status':
          SewooPrinter._status = call.arguments;
          PrinterEvent event = PrinterEvent(call.method,SewooPrinter._status);
          callback( event );
          break;
        default:
          print('Method not found');
          break;
      }
      return null;
    } as Future<dynamic> Function(MethodCall)?);
  }

  static int _mm2dots(int mm) {
    const millimeter = 7.559055118110236;
    return (mm * millimeter).floor();
  }

  static Future<bool> _checkStoragePermission() async {
    var request = await Permission.storage.request();
    return request.isGranted;
  }

  static Future<String> _saveDocument( SewooDocument doc ) async {

    String fileName = "page.png";

    Directory imgDir = await (getExternalStorageDirectory() as FutureOr<Directory>);
    final String path = "${imgDir.path}/$fileName";
    final file = File(path);

    await for (var page in Printing.raster(doc.content as Uint8List, dpi: SewooPrinter._printerDpi as double)) {

      final pg = await page.toImage();
      final ByteData byteData = await (pg.toByteData(format: ImageByteFormat.png) as FutureOr<ByteData>);
      Uint8List bytes = byteData.buffer.asUint8List();
      
      if(doc.downToUp!) {
        im.Image image = im.decodeImage( bytes )!;
        im.Image rotatedImage = im.copyRotate( image , 180);
        bytes  = im.encodePng(rotatedImage) as Uint8List;
      }
      await file.writeAsBytes( bytes );
    }
    return path;
  }

  static Future<String?> printPriceTag(
    PriceTagData priceTag, { int copies = 1, bool downToUp = true }) async {

    if (copies <= 0) {
      _status = 'Copies should be between 1 and 20';
      print(_status);
      return _status;
    }

    final content = await PriceTagLayout.buildDocument(priceTag);
    SewooDocument document = SewooDocument(
      content: content,
      downToUp: downToUp
    );
    
    final String path = await _saveDocument( document );

    if ( await _checkStoragePermission() ) {
      String status = 'Printing';

      try {
        bool success = await (_channel.invokeMethod('printImage', <String, dynamic> {
          "path": path,
          "width": _mm2dots( 39 ), 
          "height": _mm2dots( 102 ),
          "copies": copies
        }) as FutureOr<bool>);
        status = success ? 'Success' : 'Fail: Image not found';
        
      } on PlatformException catch (e) {
        status = 'Failed: ${e.message}';
      }
      _status = status;

    } else {
      _status = 'Permission Denied';
    }
    return _status;
  }
  
}
