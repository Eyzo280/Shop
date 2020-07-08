import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/orders.dart';
import '../providers/cart.dart' as cartData;
import 'package:shopapp/pages/orders.dart';
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/products.dart';

class DrawerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [Colors.blue, Colors.purple],
          ),
        ),
        child: Theme(
          data: ThemeData(
            textTheme: TextTheme(
              bodyText1: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Consumer<User>(
                          builder: (context, user, _) {
                            return Text(
                              user.displayName,
                              style: const TextStyle(fontSize: 25),
                            );
                          },
                        ),
                        Consumer<Auth>(
                          builder: (context, auth, _) {
                            return IconButton(
                                icon: const Icon(Icons.exit_to_app),
                                onPressed: () {
                                  Provider.of<cartData.Cart>(context, listen: false).clearData();
                                  Provider.of<Orders>(context, listen: false).clear();
                                  auth.signOut();
                                });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                /*
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  */
              ),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.shop,
                    color: Colors.white,
                  ),
                  title: const Text('Shop'),
                ),
              ),
              const Divider(),
              FlatButton(
                onPressed: () {},
                child: ListTile(
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: const Text('Manage Products'),
                ),
              ),
              const Divider(),
              FlatButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/Orders');
                },
                child: ListTile(
                  leading: const Icon(
                    Icons.credit_card,
                    color: Colors.white,
                  ),
                  title: const Text('Orders'),
                ),
              ),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
