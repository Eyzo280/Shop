import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/customRoutes/right.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/pages/login.dart';
import 'package:shopapp/pages/manage_products.dart';
import 'package:shopapp/pages/orders.dart';
import './providers/orders.dart';
import 'package:shopapp/pages/shop.dart';
import './pages/cart.dart' as page;
import 'package:shopapp/providers/auth.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget main(auth) {
      return MaterialApp(
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
        home: auth != null ? Shop() : LoginPage(),
        initialRoute: '/',
        onGenerateRoute: (RouteSettings settings) {
          switch (settings.name) {
            case '/loginPage':
              return SlideRightRoute(
                page: LoginPage(),
                settings: settings,
              );
            case '/Orders':
              return SlideRightRoute(
                page: OrdersPage(),
                settings: settings,
              );
            case '/Cart':
              return new SlideRightRoute(
                page: page.Cart(),
                settings: settings,
              );
            case '/ManageProducts':
              return new SlideRightRoute(
                page: ManageProducts(),
                settings: settings,
              );

            default:
              return new SlideRightRoute(
                page: Shop(),
                settings: settings,
              );
          }
        },

        /*
        routes: {
          // LoginPage.routeName: (context) => LoginPage(),
          OrdersPage.routeName: (_) => OrdersPage(),
          page.Cart.routeName: (_) => page.Cart(),
          ManageProducts.routeName: (_) => ManageProducts(),
        },
        */
      );
    }

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
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
        ChangeNotifierProvider.value(
          value: Products(),
        ),
      ],
      child: Consumer<User>(builder: (context, auth, _) {
        return auth != null
            ? StreamProvider<List<Product>>.value(
                value: Products().streamProducts, child: main(auth))
            : main(auth);
      }),
    );
  }
}
