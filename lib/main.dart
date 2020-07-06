import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/pages/login.dart';
import 'package:shopapp/pages/shop.dart';
import './pages/cart.dart' as page;
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User>.value(
          value: Auth().user,
        ),
        Provider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
      ],
      child: Consumer<User>(
        builder: (context, auth, _) => MaterialApp(
          title: 'Shop App',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                color: Colors.purple,
                fontWeight: FontWeight.bold,
              ),
            ),
            accentColor: Colors.purple,
            buttonTheme: ButtonThemeData(buttonColor: Colors.purple),
            appBarTheme: AppBarTheme(color: Colors.purple),
            buttonColor: Colors.purple,
            disabledColor: Colors.purple[200],
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.red, // Blad przy logowaniu
              elevation: 10,
            ),
          ),
          home: auth != null
              ? StreamProvider<List<Product>>.value(
                  value: Products().streamProducts,
                  child: Shop(),
                )
              : LoginPage(),
          initialRoute: '/',
          routes: {
            // LoginPage.routeName: (context) => LoginPage(),
            page.Cart.routeName: (_) => page.Cart(),
          },
        ),
      ),
    );
  }
}
