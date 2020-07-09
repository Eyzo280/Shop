import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/models/product.dart';

class Products with ChangeNotifier {
  final _firestore = Firestore.instance.collection('Products');

  Map<String, Product> _myProducts = {};

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
            _myProducts.putIfAbsent(
                doc.documentID,
                () => Product(
                      uid: doc.documentID ?? null,
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

  Future editMyProduct({Product product}) async {
    try {
      await Firestore.instance
          .collection('Products')
          .document(product.uid)
          .updateData({
        'description': product.description,
        'imageUrl': product.imageUrl,
        'name': product.name,
        'price': product.price,
      }).whenComplete(() {
        _myProducts.update(
            product.uid,
            (value) => Product(
                  uid: product.uid ?? value.uid,
                  createUid: product.createUid ?? value.createUid,
                  description: product.description ?? value.description,
                  imageUrl: product.imageUrl ?? value.imageUrl,
                  name: product.name ?? value.name,
                  price: product.price ?? value.price,
                ));
        notifyListeners();
      });
    } catch (err) {
      print(err);
    }
  }

  Stream<List<Product>> get streamProducts {
    print('Pobralo dane');

    return _firestore.snapshots().map(_product);
  }

  List<Product> get myProducts {
    List<Product> list = [];
    _myProducts.forEach((key, value) {
      list.add(value);
    });
    return list;
  }
}
