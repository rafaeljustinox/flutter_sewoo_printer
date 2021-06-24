import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:sewoo_printer/pricetag_data.dart';

class PriceTagLayout {
  /*
  1mm real = 2.857142857 no Widget
  A faixa amarela da etiqueta é 51mm de largura
  Portanto = 51 * 2.85.. = 145,7142
  altura = 27mm * 2.85.. = 
  */
  static final labelWidth = 37.0; // Milimeters, might be without margin
  static final labelHeight = 95.5; // Milimeters, might be without margin
  
  static Map<String,String> _formatPrice(num price) {
    String unit;
    String cents;
    String separator = ',';
    List<String> parts = price.toString().split('.');

    if (parts.length <= 1) {
      unit = unit.toString();
      cents = '00';
    } else {
      unit = parts[0];
      cents = parts[1].length == 1 ? '${ parts[1]}0' : parts[1].substring(0,2);
    }
    return {
      "unit" : unit,
      "cents" : cents,
      "separator": separator,
    };
  }

  static String _formatDate(DateTime date) {
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();

    month = month.length == 1 ? '0' + month : month;


    return '$day/$month/$year';
    
  }

  static List<int> buildDocument(PriceTagData priceTag) {
    
    final doc = Document();

    doc.addPage(
      Page(
        orientation: PageOrientation.landscape,
        pageFormat: PdfPageFormat(
          PriceTagLayout.labelWidth * PdfPageFormat.mm,
          PriceTagLayout.labelHeight * PdfPageFormat.mm,
          marginAll: 0.0,
        ),
        build: (context) => _buildContent(priceTag)
      ),
    );

    return doc.save();
  }

  static _buildDescription(PriceTagData priceTag) {

    return Container(
      child: Padding(
        padding: EdgeInsets.only(right: 4.0),
        child: Text(
          priceTag.description,
          style: TextStyle(
            fontSize: 10.0, 
          )
        )
      )
    );
  }

  static _buildPrice(PriceTagData priceTag) {

    Map<String,String> formattedPrice 
      = PriceTagLayout._formatPrice(priceTag.price);
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          priceTag.currency,
          style: TextStyle(
            fontSize: 12,
            letterSpacing: -1.0,
            fontWeight: FontWeight.bold
          )
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${formattedPrice['unit']}${formattedPrice['separator']}',
              style: TextStyle(
                fontSize: 46,
                letterSpacing: -3.0,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              '${formattedPrice['cents']}',
              style: TextStyle(
                fontSize: 20,
                letterSpacing: 0.2,
                fontWeight: FontWeight.bold,
              )
            ),
          ]
        )
      ]
    );
  }

  static _buildPromoPrice(PriceTagData priceTag) {

    Map<String,String> formattedPrice 
      = PriceTagLayout._formatPrice(priceTag.promoPrice);

    if (priceTag.promoPrice == 0 || priceTag.promoPriceQuantity == 0) {
      return SizedBox();
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4.0),
              child: Text(
                ('Acima de').toUpperCase(),
                style: TextStyle(
                  fontSize: 6,
                  fontWeight: FontWeight.bold
                ),
              ),
            ),
            Text(
              (priceTag.promoPriceQuantity).toString(),
              style: TextStyle(
                fontSize: 13,
                letterSpacing: -0.5,
                fontWeight: FontWeight.bold
              ),
            ),
          ]
        ),
        
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                priceTag.currency,
                style: TextStyle(
                  fontSize: 7,
                  letterSpacing: -1.0,
                  fontWeight: FontWeight.bold
                )
              ),
            ),
            Text(
              '${formattedPrice['unit']}${formattedPrice['separator']}',
              style: TextStyle(
                fontSize: 13,
                letterSpacing: -0.5,
                fontWeight: FontWeight.bold
              ),
            ),
            Text(
              formattedPrice['cents'],
              style: TextStyle(
                fontSize: 10,
                //letterSpacing: 0.2,
                fontWeight: FontWeight.bold,
              )
            )
          ]
        )
      ]
    );
  }

  static _buildBarCode(PriceTagData priceTag) {
    const barCodeBoxheight = 14.0 * PdfPageFormat.mm;
    const barCodeHeight = 7.5 * PdfPageFormat.mm;

    return SizedBox(
      height: barCodeBoxheight,
      width: double.maxFinite,
      child: Container(
        child: Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              (priceTag.barCode).toString(),
                style: TextStyle(
                fontSize: 8.0, 
                fontWeight: FontWeight.bold
              )
            ),
            Padding(
              padding: EdgeInsets.only( right: 4.0 ),
              child: SizedBox(
                height: barCodeHeight,
                child: BarcodeWidget(
                  drawText: false,
                  color: PdfColor.fromHex("#000000"),
                  barcode: Barcode.code128(),
                  data: priceTag.barCode.toString(),
                ),
              )
            )
          ]
        ),
      ) 
    );
  }

  static _buildFooter(PriceTagData priceTag) {

    return Padding(
      padding: EdgeInsets.only(top: 3.0),
      child: SizedBox(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              priceTag.codigo.toString(),
              style: TextStyle(
                fontSize: 7.0,
              )
            ),
            Text(
              PriceTagLayout._formatDate(DateTime.now()),
              style: TextStyle(
                fontSize: 8.0,
              )
            ),
          ]
        )
      )
    );
    
  }

  static _buildContent(PriceTagData priceTag) {
    var yellowBoxWidth = 51 * PdfPageFormat.mm;
    var yellowBoxHeight = 28 * PdfPageFormat.mm;
    var leftMargin = 10.0 * PdfPageFormat.mm;// 26.5;
    
    return Container(
      constraints: BoxConstraints.expand(),
      decoration: BoxDecoration(
        //border: Border.all(width: borderWidth),
        color: PdfColor.fromHex('#ffffff')
      ),
      padding: EdgeInsets.only(
        left: leftMargin,
        top: 2.0,
        right: 2.0,
        bottom: 0.0
      ),
      child: Row(
        //direction: Axis.horizontal,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.only(
                left: 4.0,
                top: 8.0,
                right: 2.0,
                bottom: 0.0
              ),
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                border:  Border(
                  left: BorderSide(
                    style: BorderStyle.dashed,
                    width: 0.5, color: PdfColor.fromHex('#ababab')
                  ),
                ),
              ),
              child: Wrap(
                runAlignment: WrapAlignment.spaceBetween,
                children: [
                  _buildDescription(priceTag),
                  _buildBarCode(priceTag)
                ]
              )
            )
          ),
          Column(
            children: [
              SizedBox(
                width: yellowBoxWidth,
                height: yellowBoxHeight,//double.maxFinite,
                child: Padding(
                  padding: EdgeInsets.only(
                    top: 1.0,
                    right: 0.0,
                    bottom: 0.0
                  ),
                  child: Container(
                    padding: EdgeInsets.only(
                      left: 4.0,
                      top: 4.0,
                      right: 4.0,
                      bottom: 2.0
                    ),
                    constraints: BoxConstraints.expand(),
                    decoration: BoxDecoration(
                      color: PdfColor.fromHex('#fffa73'),
                      //border: Border.all(width: 1.0)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildPrice( priceTag ),
                        _buildPromoPrice( priceTag )
                      ]
                    ),
                  ),
                )
              ),
              _buildFooter( priceTag )
            ]
          ),
        ]
      )
    );
  }
}
