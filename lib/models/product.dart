import 'package:flutter/cupertino.dart';

class Product {
  String uid;
  String createUid;
  String description;
  String imageUrl;
  String name;
  double price;

  Product({
    @required this.uid,
    @required this.createUid,
    @required this.description,
    @required this.imageUrl,
    @required this.name,
    @required this.price,
  });
}

class ProductFromOrder {
  String description;
  String imageUrl;
  String name;
  int quantity;

  ProductFromOrder({
    this.description,
    this.imageUrl,
    this.name,
    this.quantity,
  });
}
