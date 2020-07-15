import 'package:flutter/cupertino.dart';

class CartItem {
  final String uid;
  final String name;
  final List<String> imageUrls;
  final String decription;
  final double price;
  final int quantity;

  CartItem({
    @required this.uid,
    @required this.name,
    @required this.imageUrls,
    @required this.decription,
    @required this.price,
    @required this.quantity,
  });
}
