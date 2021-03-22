import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

class PdfDocGenerator {

  /*
    1mm real = 2.857142857 no Widget
    A faixa amarela da etiqueta é 51mm de largura
    Portanto = 51 * 2.85.. = 145,7142

    altura = 27mm * 2.85.. = 
  */
  static final widgetFactor = 2.857;

  static final printerPaperWidth = 37.0; // Milimeters, might be without margin
  static final printerPaperHeight = 95.5; // Milimeters, might be without margin
  
  static List<int> buildDocument() {

    final doc = Document();

    doc.addPage(
      Page(
        orientation: PageOrientation.landscape,
        pageFormat: PdfPageFormat(
          PdfDocGenerator.printerPaperWidth * PdfPageFormat.mm,
          PdfDocGenerator.printerPaperHeight * PdfPageFormat.mm,
          marginAll: 0.0,
        ),
        build: (context) => _buildContent()
      ),
    );

    return doc.save();
  }

  static _buildContent() {

    //var yellowBoxWidth = 51 * PdfDocGenerator.widgetFactor;
    //var yellowBoxHeight = 28 * PdfDocGenerator.widgetFactor;
    var yellowBoxWidth = 51 * PdfPageFormat.mm;
    var yellowBoxHeight = 28 * PdfPageFormat.mm;
    var leftMargin = 10.0 * PdfPageFormat.mm;// 26.5;
    var barCodeBoxheight = 14.0 * PdfPageFormat.mm;
    var barCodeHeight = 7.5 * PdfPageFormat.mm;

    print('Testando: ${10.0 * PdfPageFormat.mm}');

    const borderWidth = 2.0;
    const margin = 8.0;

    const description = 'COPO PLAST TRANSP PP 250ML';
    const barCode = '7896030822506';
    const price = '6,99';
    const priceAlt = price;
    const currency = 'R\$';

    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        //border: Border.all(width: borderWidth),
        color: PdfColor.fromHex('#ffffff')
      ),
      padding: EdgeInsets.only(left: leftMargin, top: 2.0, right: 2.0, bottom: 0.0),
      child: Row(
        //direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(left: 4.0, top: 8.0, right: 2.0, bottom: 0.0),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                border:  Border(
                  left: BorderSide(
                    style: BorderStyle.dashed,
                    width: 0.5, color: PdfColor.fromHex('#ababab')
                  ),
                ),
                /* border:  Border.all(
                  width: 1.0,
                  color: PdfColor.fromHex('#000000')
                ) */
              ),
              child: Wrap(
                runAlignment: WrapAlignment.spaceBetween,
                children: [
                  Container(
                    child: Padding(
                      padding: EdgeInsets.only(right: 4.0),
                      child: Text(
                        description,
                        style: TextStyle(
                          fontSize: 12.0, 
                        )
                      )
                    )
                  ),
                  SizedBox(
                    height: barCodeBoxheight,
                    width: double.maxFinite,
                    child: Container(
                      /* decoration: BoxDecoration(
                        border: Border.all(
                          width: 2.0,
                          color: PdfColor.fromHex('#00ff00')
                        )
                      ), */
                      child: Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Text(
                            barCode,
                              style: TextStyle(
                              fontSize: 8.0, 
                              fontWeight: FontWeight.bold
                            )
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 4.0),
                            child: SizedBox(
                              height: barCodeHeight,
                              child: BarcodeWidget(
                                drawText: false,
                                color: PdfColor.fromHex("#000000"),
                                barcode: Barcode.code128(),
                                data: barCode,
                              ),
                            )
                          )
                        ]
                      ),
                    ) 
                  ),
                ]
              )
            )
          ),
          SizedBox(
            width: yellowBoxWidth,
            height: yellowBoxHeight,//double.maxFinite,
            child: Padding(
              padding: EdgeInsets.only(top: 1.0, right: 0.0, bottom: 0.0),
              child: Container(
                constraints: BoxConstraints.expand(),
                decoration: BoxDecoration(
                  color: PdfColor.fromHex('#fffa73'),
                  /* border: Border.all(
                    width: 0.5,
                    color: PdfColor.fromHex('#000000')
                  ) */
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      currency,
                      style: TextStyle(
                        fontSize: 10,
                        letterSpacing: -0.0,
                      )
                    ),
                    Text(
                      '${price.split(',')[0]},',
                      style: TextStyle(
                        fontSize: 46,
                        letterSpacing: -3.0,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      price.split(',')[1],
                      style: TextStyle(
                        fontSize: 24,
                        letterSpacing: 0.2,
                        fontWeight: FontWeight.bold,
                      )
                    ),
                  ]
                )
              ),
            )
          ),
        ]
      )
    );
  }
}
