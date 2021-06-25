class PriceTagData {
  int barCode;

  String currency;

  int code;

  String date;

  String description;

  num price;

  num promoPrice;

  int promoPriceQuantity;

  String package;

  String brand;

  PriceTagData({
    this.barCode = 0,
    this.currency = 'R\$',
    this.code = 0,
    this.date = '',
    this.description = '',
    this.price = 0,
    this.promoPrice = 0,
    this.promoPriceQuantity = 0,
    this.package = '',
    this.brand = ''
  });
  
}