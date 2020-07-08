class Order {
  String uid;
  int countProducts;
  String dateOfPurchase;
  bool delivery; // True oznacza zakonczona dostawe.
  bool paided; // True oznacza zakonczona platnosc.
  String payment;
  double totalPrice;

  Order({
    this.uid,
    this.countProducts,
    this.dateOfPurchase,
    this.delivery,
    this.paided,
    this.payment,
    this.totalPrice,
  });
}
