class IPriceTagData {
  int barCode;
  int codigo;
  String currency;
  String description;
  num price;
  num promoPrice;
  String date;
}

class PriceTagData implements IPriceTagData {
  @override
  int barCode;

  @override
  String currency;

  @override
  int codigo;

  @override
  String date;

  @override
  String description;

  @override
  num price;

  @override
  num promoPrice;

  PriceTagData({
    int barCode = 0,
    String currency = '',
    int codigo = 0,
    String date = '',
    String description = '',
    num price = 0.00,
    num promoPrice = 0.00
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