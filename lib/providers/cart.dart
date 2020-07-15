import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/order.dart';
import 'package:shopapp/widgets/snackBar.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  final _firestore = Firestore.instance.collection('Users');

  void addItemToCart({
    BuildContext ctx,
    String productUid,
    String name,
    String decription,
    List<String> imageUrls,
    double price,
  }) {
    if (_cart.containsKey(productUid)) {
      _cart.update(
        productUid,
        (existingItem) => CartItem(
          uid: existingItem.uid,
          name: existingItem.name,
          imageUrls: existingItem.imageUrls,
          decription: existingItem.decription,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _cart.putIfAbsent(
        productUid,
        () => CartItem(
            uid: productUid,
            imageUrls: imageUrls,
            decription: decription,
            name: name,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();

    // Looked SnackBar
    Scaffold.of(ctx).removeCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(
      snackBarProduct(
          context: ctx,
          productUid: productUid,
          name: name,
          price: price,
          quantity: 1),
    );
    //
    print(_cart);
  }

  void removeProductFromCart({String productUid, int removeQuantity}) {
    if (_cart.containsKey(productUid)) {
      for (var i in _cart.keys) {
        if (i == productUid) {
          if (_cart[i].quantity > 1) {
            _cart.update(
              productUid,
              (existingItem) => CartItem(
                uid: productUid,
                name: existingItem.name,
                imageUrls: existingItem.imageUrls,
                decription: existingItem.decription,
                price: existingItem.price,
                quantity: existingItem.quantity - 1,
              ),
            );
          } else {
            _cart.remove(productUid);
            break;
          }
        }
      }
    }
    notifyListeners();
    print('Undo ProductItem');
  }

  Future buyProductsFromCart({
    @required String userUid,
  }) async {
    try {
      Order order = Order(
        // Wartosc zwracana, aby miec dane do dodania w ordersach w providerze
        uid: null,
        countProducts: null,
        dateOfPurchase: null,
        delivery: null,
        paided: null,
        payment: null,
        totalPrice: null,
      );
      if (_cart.isNotEmpty) {
        DocumentReference doc =
            _firestore.document(userUid).collection('Orders').document();
        await doc.setData({
          'Payment': 'Cash',
          'TotalPrice': totalPrice,
          'CountProducts': countProductsFromCart,
          'DateOfPurchase': DateTime.now().toIso8601String(),
          'Delivery': true,
          'Paided': true,
        }).then((value) {
          order = Order(
            uid: doc.documentID,
            countProducts: countProductsFromCart,
            dateOfPurchase: DateTime.now().toIso8601String(),
            delivery: true,
            paided: true,
            payment: 'Cash',
            totalPrice: totalPrice,
          );
          for (var _productUid in _cart.keys) {
            doc.collection('Products').document(_productUid).setData({
              'name': _cart[_productUid].name ?? null,
              'price': _cart[_productUid].price ?? null,
              'decription': _cart[_productUid].decription ?? null,
              'imageUrls': _cart[_productUid].imageUrls ?? null,
              'quantity': _cart[_productUid].quantity ?? null,
            });
          }
        }).then((v) {
          _cart.clear();
          notifyListeners();
        });
        return order;
      } else {
        print('Cart is Empty');
      }
    } catch (err) {
      print(err);
    }
  }

  int get countProductsFromCart {
    int count = 0;
    _cart.forEach((key, value) {
      count += value.quantity;
    });
    return count;
  }

  List<CartItem> get productsFromCart {
    List<CartItem> list = [];
    _cart.forEach((key, value) {
      list.add(value);
    });
    return list;
  }

  double get totalPrice {
    double totalprice = 0;
    _cart.forEach((key, value) {
      totalprice += (value.price * value.quantity);
    });

    return totalprice;
  }

  void clearData() {
    _cart.clear();
  }
}
