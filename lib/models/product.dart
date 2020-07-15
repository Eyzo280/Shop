import 'package:flutter/cupertino.dart';

class Product {
  String uid;
  String createUid;
  String description;
  List<String> imageUrls;
  String name;
  double price;

  Product({
    @required this.uid,
    @required this.createUid,
    @required this.description,
    @required this.imageUrls,
    @required this.name,
    @required this.price,
  });
}

class ProductFromOrder {
  String description;
  List<String> imageUrls;
  String name;
  int quantity;
  double price;

  ProductFromOrder({
    this.description,
    this.imageUrls,
    this.name,
    this.quantity,
    this.price
  });
}
