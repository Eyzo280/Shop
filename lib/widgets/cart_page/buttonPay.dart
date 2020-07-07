import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import '../../providers/cart.dart';

class CartButtonPayment extends StatefulWidget {
  @override
  _CartButtonPaymentState createState() => _CartButtonPaymentState();
}

class _CartButtonPaymentState extends State<CartButtonPayment> {
  bool loadingPayment = false;
  @override
  Widget build(BuildContext context) {
    final userUid = Provider.of<User>(context).uid;
    final cart = Provider.of<Cart>(context);

    return loadingPayment
        ? CircularProgressIndicator()
        : FloatingActionButton.extended(
            onPressed: loadingPayment || cart.productsFromCart.isEmpty
                ? null
                : () async {
                    setState(() {
                      loadingPayment = true;
                    });

                    await cart
                        .buyProductsFromCart(userUid: userUid)
                        .then((value) {
                      setState(() {
                        loadingPayment = false;
                      });
                    });
                    print('Buy Products From Cart');
                  },
            label: Text('Buy'),
            icon: Icon(Icons.payment),
          );
  }
}
