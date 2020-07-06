import 'package:flutter/cupertino.dart';

class CartItem {
  final String uid;
  final String name;
  final String imageUrl;
  final double price;
  final int quantity;

  CartItem({
    @required this.uid,
    @required this.name,
    @required this.imageUrl,
    @required this.price,
    @required this.quantity,
  });
}
