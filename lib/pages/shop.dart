import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/drawer.dart';
import '../widgets/product.dart';
import '../pages/cart.dart' as page;

class Shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;

    var user = Provider.of<User>(context);
    List<Product> products = Provider.of<List<Product>>(context) ?? null;

    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        centerTitle: true,
        actions: <Widget>[
          Consumer<Cart>(
            builder: (context, _cart, childIconButton) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Stack(
                    children: <Widget>[
                      childIconButton,
                      Positioned(
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(1),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 15,
                            minHeight: 15,
                          ),
                          child: Text(
                            _cart.countProductsFromCart.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.pushNamed(context, page.Cart.routeName);
              },
            ),
          ),
        ],
      ),
      drawer: DrawerApp(),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [Colors.blue, Colors.purple],
          ),
        ),
        child: products == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : GridView.builder(
                padding: const EdgeInsets.all(8.0),
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 10 / 8,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  return ProductWidget(
                    product: products[index],
                    deviceSize: deviceSize,
                  );
                },
              ),
      ),
    );
  }
}
