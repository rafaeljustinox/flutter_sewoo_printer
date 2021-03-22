class IPriceTagData {
  String barCode;
  String codigo;
  String currency;
  String description;
  String price;
  String promoPrice;
  String date;
}

class PriceTagData implements IPriceTagData {
  @override
  String barCode;

  @override
  String currency;

  @override
  String codigo;

  @override
  String date;

  @override
  String description;

  @override
  String price;

  @override
  String promoPrice;

  PriceTagData({
    String barCode = '',
    String currency = '',
    String codigo = '',
    String date = '',
    String description = '',
    String price = '',
    String promoPrice = ''
  }){
    this.barCode = barCode;
    this.currency = currency;
    this.codigo = codigo;
    this.date = date;
    this.description = description;
    this.price = price;
    this.promoPrice = price;
  }

}