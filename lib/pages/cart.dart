import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/widgets/cart_page/buttonPay.dart';
import 'package:shopapp/widgets/cart_page/listProducts.dart';
import 'package:shopapp/widgets/shop/product_detail.dart';
import '../providers/cart.dart' as cartdata;
import 'package:shopapp/models/cart.dart';

class Cart extends StatelessWidget {
  static const routeName = '/Cart';

  Widget info(
      {BuildContext context, cartdata.Cart cart, List<CartItem> cartProducts}) {
    return Flexible(
      fit: FlexFit.tight,
      child: Center(
        child: Stack(
          children: <Widget>[
            Container(
              alignment: Alignment.topRight,
              padding: EdgeInsets.all(10),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.all(Radius.circular(50)),
                ),
                child: Center(
                    child: Text(
                  cart.countProductsFromCart.toString(),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                '${cart.totalPrice} \$',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var userUid = Provider.of<User>(context).uid;
    var cart = Provider.of<cartdata.Cart>(context);
    List<CartItem> cartProducts = cart.productsFromCart;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Cart'),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          info(
            context: context,
            cart: cart,
            cartProducts: cartProducts,
          ),
          Divider(),
          CartListProducts(
            cartProducts: cartProducts,
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: CartButtonPayment(),
    );
  }
}
