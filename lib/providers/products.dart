import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/models/product.dart';

class Products with ChangeNotifier {
  final _firestore = Firestore.instance.collection('Products');

  List<Product> _myProducts = [];

  List<Product> _product(QuerySnapshot snap) {
    return snap.documents.map((DocumentSnapshot doc) {
      return Product(
        uid: doc.documentID,
        createUid: doc['createUid'] ?? null,
        description: doc['description'] ?? null,
        imageUrl: doc['imageUrl'] ?? null,
        name: doc['name'] ?? null,
        price: doc['price'] ?? null,
      );
    }).toList();
  }

  Future fetchMyProducts({@required String userUid}) async {
    try {
      if (_myProducts.isEmpty) {
        await _firestore
            .where('createUid', isEqualTo: userUid)
            .getDocuments()
            .then((value) {
          for (var doc in value.documents) {
            _myProducts.add(Product(
              uid: doc.data['uid'] ?? null,
              createUid: doc.data['createUid'] ?? null,
              description: doc.data['description'] ?? null,
              imageUrl: doc.data['imageUrl'] ?? null,
              name: doc.data['name'] ?? null,
              price: doc.data['price'] ?? null,
            ));
          }
        }).whenComplete(() {
          notifyListeners();
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Stream<List<Product>> get streamProducts {
    print('Pobralo dane');

    return _firestore.snapshots().map(_product);
  }

  List<Product> get myProducts {
    return _myProducts;
  }
}
