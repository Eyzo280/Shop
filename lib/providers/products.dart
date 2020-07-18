import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:shopapp/models/product.dart';

class Products with ChangeNotifier {
  final _firestore = Firestore.instance.collection('Products');

  FirebaseStorage _storage = FirebaseStorage.instance;

  Map<String, Product> _myProducts = {};

  List<Product> _product(QuerySnapshot snap) {
    return snap.documents.map((DocumentSnapshot doc) {
      return Product(
        uid: doc.documentID,
        createUid: doc['createUid'] ?? null,
        description: doc['description'] ?? null,
        imageUrls: List<String>.from(doc.data['imageUrls']) ?? null,
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
                      imageUrls:
                          List<String>.from(doc.data['imageUrls']) ?? null,
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

  Future editMyProduct({Product product, String userUid}) async {
    var doc = _firestore.document(product.uid);
    List<String> imageUrls = [];
    try {
      // Dodawanie nowych zdj do Firebase Storage, jezeli jest taka potrzeba.
      for (int i = 0; i <= product.imageUrls.length - 1; i++) {
        StorageReference reference =
            _storage.ref().child('Products/$userUid/${doc.documentID}/Image$i');
        if (!product.imageUrls[i].contains('https://')) {
          StorageUploadTask uploadTask =
              reference.putFile(File(product.imageUrls[i]));
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          await taskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            imageUrls.add(downloadUrl.toString());
            print(downloadUrl);
          });
        } else {
          imageUrls.add(product.imageUrls[i]);
        }
      }

      await doc.updateData({
        'description': product.description,
        'imageUrls': imageUrls,
        'name': product.name,
        'price': product.price,
      }).catchError((err) {
        throw err;
      }).then((_) {
        _myProducts.update(
            product.uid,
            (value) => Product(
                  uid: product.uid ?? value.uid,
                  createUid: product.createUid ?? value.createUid,
                  description: product.description ?? value.description,
                  imageUrls: imageUrls ?? value.imageUrls,
                  name: product.name ?? value.name,
                  price: product.price ?? value.price,
                ));
        notifyListeners();
      });
    } catch (err) {
      print(err);
      throw err;
    }
  }

  Future addNewMyProduct({
    Product product,
    String userUid,
  }) async {
    var doc = _firestore.document();
    List<String> imageUrls = [];

    try {
      // Dodawanie nowych zdj do Firebase Storage.
      for (int i = 0; i <= product.imageUrls.length - 1; i++) {
        StorageReference reference =
            _storage.ref().child('Products/$userUid/${doc.documentID}/Image$i');
        if (!product.imageUrls[i].contains('gs://')) {
          StorageUploadTask uploadTask =
              reference.putFile(File(product.imageUrls[i]));
          StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
          await taskSnapshot.ref.getDownloadURL().then((downloadUrl) {
            imageUrls.add(downloadUrl.toString());
            print(downloadUrl);
          });
        } else {
          imageUrls.add(product.imageUrls[i]);
        }
      }
      await doc.setData({
        'createUid': userUid,
        'description': product.description,
        'imageUrls': imageUrls,
        'name': product.name,
        'price': product.price,
      }).whenComplete(() {
        _myProducts.putIfAbsent(
            doc.documentID,
            () => Product(
                  uid: doc.documentID ?? null,
                  createUid: userUid ?? null,
                  description: product.description ?? null,
                  imageUrls: imageUrls ?? '',
                  name: product.name ?? null,
                  price: product.price ?? 0.0,
                ));
        notifyListeners();
      });
    } catch (err) {
      print(err);
    }
  }

  Future removeMyProduct({String productUid}) async {
    try {
      await _firestore.document(productUid).delete().catchError((err) {
        throw err;
      }).then((value) {
        _myProducts.removeWhere((key, value) => key == productUid);
      });
    } catch (err) {
      print(err);
      throw err;
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
