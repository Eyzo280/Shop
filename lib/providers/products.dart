import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/models/product.dart';

class Products {
  final _firestore = Firestore.instance.collection('Products');

  List<Product> _product(QuerySnapshot snap) {
    return snap.documents.map((DocumentSnapshot doc) {
      return Product(
        createUid: doc['createUid'] ?? null,
        description: doc['description'] ?? null,
        imageUrl: doc['imageUrl'] ?? null,
        name: doc['name'] ?? null,
        price: doc['price'] ?? null,
      );
    }).toList();
  }

  Stream<List<Product>> get streamProducts {
    print('Pobralo dane');

    return _firestore.snapshots().map(_product);
  }
}
