import 'package:flutter/material.dart';

import 'package:sewoo_printer/printer_consts.dart';
import 'package:sewoo_printer/pricetag_layout.dart';
import 'package:sewoo_printer/pricetag_data.dart';
import 'package:sewoo_printer/printer_events.dart';
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(title: 'Sewoo Printer CPCL'),
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

  final printerIP = '192.168.0.107';
  final printerPort = 9100;
  final printerDpi = PrinterConsts.dpi;
  final _thumbnails = <ImageProvider>[];
  
  //String _status = '';
  bool _connected = false;
  // Reading direction (down to up = left to right)
  bool _downToUp = true;

  PriceTagData _priceTag = PriceTagData(
    barCode: 7896030822506,
    code: 98765,
    currency: 'R\$',
    date: '01/08/2021',
    description: 'BALOES SAO ROQUE CORES SORTIDAS 50U TESTE',
    //description: 'COPO PLAST TRANSP PP 250ML',
    price: 126.9,
    promoPrice: 96.9,
    promoPriceQuantity: 100,
    brand: 'DIVERTS',
    package: 'UN'
  );
  
  initializePrinter() {

    SewooPrinter.listenEvents(( PrinterEvent event ) {

      switch (event.name) {
        case 'connect':
          _onConnectionChanged(event.value);
          break;
        case 'status':
          _onStatusChanged(event.value);
          break;
        default:
          print('Event not identified: ${event.name}');
          break;
      }
    });
  }

  @override
  void initState() {
    initializePrinter();
    SewooPrinter.connect(printerIP, printerPort);
    _updateThumbnails();
    super.initState();
  }

  @override
  void reassemble() {
    initializePrinter();
    SewooPrinter.connect(printerIP, printerPort);
    _updateThumbnails();
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
    print(status);
  }

  _connect() {
    if (SewooPrinter.connected) {
      SewooPrinter.disconnect();
    } else {
      SewooPrinter.connect(printerIP, printerPort);
    }
  }

  /* _getPrinterStatus() async {
    _status = await SewooPrinter.getStatus();
  } */

  _printPriceTag() async {
    await SewooPrinter.printPriceTag(
      this._priceTag,
      downToUp: this._downToUp,
      copies: 1
    );
  }

  void _updateThumbnails() async {
    _thumbnails.clear();

    var doc = await PriceTagLayout.buildDocument(this._priceTag);

    await for ( var page in Printing.raster(doc, dpi: PrinterConsts.dpi ) ) {
      if (_thumbnails.length == 0){
        // Limits to only 1 image
        _thumbnails.add(PdfRasterImage(page));
      }
    }
    setState(() {});
  }

  void _invertOrientation() {
    setState(() {
      _downToUp = !_downToUp;
    });
    _updateThumbnails();
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
              itemCount: _thumbnails.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) => Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0), //50.0
                child: Card(
                  elevation: 8,
                  child: RotatedBox(
                    //quarterTurns: 3,
                    quarterTurns: this._downToUp ? 2 : 0,
                      child: Image(
                      image: _thumbnails[index],
                      fit: BoxFit.contain,
                    ),
                  )
                ),
              ),
            ),
          ) 
        ),
      ),
      floatingActionButton: Visibility(
        //duration: Duration(milliseconds: 500),
        //opacity: _connected ? 1.0 : 0.0,
        visible: _connected,
        child: FloatingActionButton.extended(
          onPressed: _printPriceTag,
          tooltip: 'Conectar',
          label: Row(
            children: [
            Icon(Icons.print),
            SizedBox(width: 8.0),
            Text('Print'),
          ]),
        )
      )
    );
  }

}
