import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/widgets/snackBar.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cart = {};

  void addItemToCart({
    BuildContext ctx,
    String productUid,
    String name,
    String imageUrl,
    double price,
  }) {
    if (_cart.containsKey(productUid)) {
      _cart.update(
        productUid,
        (existingItem) => CartItem(
          uid: existingItem.uid,
          name: existingItem.name,
          imageUrl: existingItem.imageUrl,
          price: existingItem.price,
          quantity: existingItem.quantity + 1,
        ),
      );
    } else {
      _cart.putIfAbsent(
        productUid,
        () => CartItem(
            uid: productUid,
            imageUrl: imageUrl,
            name: name,
            price: price,
            quantity: 1),
      );
    }
    notifyListeners();
    Scaffold.of(ctx).hideCurrentSnackBar();
    Scaffold.of(ctx).showSnackBar(
      snackBarProduct(
          context: ctx,
          productUid: productUid,
          name: name,
          price: price,
          quantity: 1),
    );
    print(_cart);
  }

  void undoLastProducts({String productUid, int removeQuantity}) {
    /*
    if (_cart.containsKey(productUid)) {
      print('tu');
      _cart.forEach((key, value) {
        if (key == productUid && value.quantity > 1) {
          _cart.update(
            productUid,
            (existingItem) => CartItem(
              uid: productUid,
              name: existingItem.name,
              price: existingItem.price,
              quantity: existingItem.quantity - 1,
            ),
          );
        } else {
          _cart.remove(productUid);
          return;
        }
      });
    }
    notifyListeners();
    print('Undo ProductItem');
    */

    if (_cart.containsKey(productUid)) {
      for (var i in _cart.keys) {
        if (i == productUid) {
          if (_cart[i].quantity > 1) {
            _cart.update(
              productUid,
              (existingItem) => CartItem(
                uid: productUid,
                name: existingItem.name,
                imageUrl: existingItem.imageUrl,
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
}
