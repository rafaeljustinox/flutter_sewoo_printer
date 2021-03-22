class PriceTagData {
  int barCode;

  String currency;

  int codigo;

  String date;

  String description;

  num price;

  num promoPrice;

  int promoPriceQuantity;

  PriceTagData({
    this.barCode = 0,
    this.currency = 'R\$',
    this.codigo = 0,
    this.date = '',
    this.description = '',
    this.price = 0,
    this.promoPrice = 0,
    this.promoPriceQuantity = 0,
  });
  
}