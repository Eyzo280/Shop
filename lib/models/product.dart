import 'package:flutter/cupertino.dart';

class Product {
  String createUid;
  String description;
  String imageUrl;
  String name;
  double price;

  Product({
    @required this.createUid,
    @required this.description,
    @required this.imageUrl,
    @required this.name,
    @required this.price,
  });
}
