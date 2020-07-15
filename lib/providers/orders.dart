import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shopapp/models/product.dart';
import '../models/order.dart';

class Orders with ChangeNotifier {
  final _firestore = Firestore.instance.collection('Users');

  List<Order> _orders = [];

  Map<String, List<ProductFromOrder>> _productsFromOrder = {};

  Future fetchOrders({String userUid, bool isEmpty}) async {
    try {
      if (isEmpty) {
        await _firestore
            .document(userUid)
            .collection('Orders')
            .orderBy('DateOfPurchase', descending: true)
            .getDocuments()
            .then(
          (value) {
            for (var doc in value.documents) {
              _orders.add(
                Order(
                  uid: doc.documentID,
                  countProducts: doc.data['CountProducts'] ?? null,
                  dateOfPurchase: doc.data['DateOfPurchase'] ?? null,
                  delivery: doc.data['Delivery'] ?? null,
                  paided: doc.data['Paided'] ?? null,
                  payment: doc.data['Payment'] ?? null,
                  totalPrice: doc.data['TotalPrice'] ?? null,
                ),
              );
            }
          },
        ).whenComplete(() => notifyListeners());
      } else {
        print('Dane orders juz sa pobrane');
      }
    } catch (err) {
      print(err);
    }
  }

  Future fetchProductFromOrder({String userUid, String orderUid}) async {
    try {
      if (!_productsFromOrder.containsKey(orderUid)) {
        await _firestore
            .document(userUid)
            .collection('Orders')
            .document(orderUid)
            .collection('Products')
            .getDocuments()
            .then((value) {
          List<ProductFromOrder> listProducts = [];
          for (var doc in value.documents) {
            listProducts.add(ProductFromOrder(
              description: doc.data['description'] ?? null,
              imageUrls: List<String>.from(doc.data['imageUrls']) ?? null,
              name: doc.data['name'] ?? null,
              quantity: doc.data['quantity'] ?? null,
              price: doc.data['price'] ?? null,
            ));
          }
          _productsFromOrder.putIfAbsent(orderUid, () => listProducts);
          print('dsas');
          notifyListeners();
        });
      } else {
        print('Produkty z tego ordera juz sa.');
      }
    } catch (err) {
      print(err);
    }
  }

  void addOrder({Order order}) {
    _orders.add(order);
  }

  List<Order> get orders {
    return _orders;
  }

  List<Order> get ordersPaided {
    return _orders.where((element) => element.paided == true).toList();
  }

  List<Order> get ordersFinished {
    return _orders.where((element) => element.delivery == true).toList();
  }

  Map<String, List<ProductFromOrder>> get productsFormOrder {
    return _productsFromOrder;
  }

  void clear() {
    _orders.clear();
    _productsFromOrder.clear();
  }
}
