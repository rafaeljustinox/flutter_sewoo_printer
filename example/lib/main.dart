import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:sewoo_printer/pdf.doc.generator.dart';
import 'package:sewoo_printer/printer.event.dart';
import 'package:sewoo_printer/sewoo_printer.dart';
import 'package:printing/printing.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try {
      platformVersion = await SewooPrinter.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}


class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final printerDpi = 203.0;
  final _images = <ImageProvider>[];
  SewooPrinter printer;
  String _status = '';
  bool _connected = false;
  // Reading direction (down to up = left to right)
  bool _downToUp = true;
  
  initializePrinter() {
    /* if (printer == null) {
      printer = new SewooPrinter();
    } */

    SewooPrinter.listenEvents(( PrinterEvent event ) {

      switch (event.name) {
        case 'connect':
          _onConnectionChanged(event.value);
          break;
        case 'status':
          _onStatusChanged(event.value);
          break;
        default:
          print('Evento não identificado');
          break;
      }
    });
  }

  @override
  void initState() {
    initializePrinter();
    SewooPrinter.connect();
    _updateImages();
    super.initState();
  }

  @override
  void reassemble() {
    initializePrinter();
    SewooPrinter.connect();
    _updateImages();
    super.reassemble();
  }

  @override
  void dispose() {
    SewooPrinter.disconnect();
    super.dispose();
  }
  
  _onConnectionChanged(bool isConnected) {
    setState(() {
      _connected = isConnected;
    });
  }

  _onStatusChanged(String status) {
    setState(() {
      _status = status;
    });
  }

  _connect() {
    if (SewooPrinter.connected) {
      SewooPrinter.disconnect();
    } else {
      SewooPrinter.connect();
    }
  }

  _getPrinterStatus() async {
    _status = await SewooPrinter.getStatus();
  }

  _printPriceTag() async {
    _status = await SewooPrinter.printImage(this._downToUp);
  }

  void _updateImages() async {
    _images.clear();

    await for (
      var page in Printing.raster(
        PdfDocGenerator.buildDocument(), dpi: printerDpi)
      ) {
      _images.add(PdfRasterImage(page));
    }
    setState(() {});
  }

  void _invertOrientation() {
    setState(() {
      _downToUp = !_downToUp;
    });
    _updateImages();

    print(_downToUp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Opacity(
              opacity: _connected ? 1 : .5,
              child: Icon(
                Icons.wifi,
              ),
            ),
            onPressed: _connect
          ),
          IconButton(
            icon: Icon(Icons.compare_arrows),
            onPressed: () => {
              _invertOrientation()
            }
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child:Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
              itemCount: _images.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0), //50.0
                child: Card(
                  elevation: 8,
                  child: RotatedBox(
                    //quarterTurns: 3,
                    quarterTurns: this._downToUp ? 2 : 0,
                      child: Image(
                      image: _images[index],
                      fit: BoxFit.contain,
                    ),
                  )
                ),
              ),
            ),
          ) 
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _printPriceTag,
        tooltip: 'Conectar',
        label: Row(
          children: [
          Icon(Icons.print),
          SizedBox(width: 8.0),
          Text('Print'),
        ]),
      ),
    );
  }
}
