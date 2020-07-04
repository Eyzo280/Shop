import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/pages/login.dart';
import 'package:shopapp/pages/shop.dart';
import 'package:shopapp/providers/auth.dart';

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
            appBarTheme: AppBarTheme(color: Colors.purple),
            buttonColor: Colors.purple,
            disabledColor: Colors.purple[200],
            snackBarTheme: SnackBarThemeData(
              backgroundColor: Colors.red,
              elevation: 10,
            ),
          ),
          home: auth != null ? Shop() : LoginPage(),
          initialRoute: '/',
          routes: {
            // LoginPage.routeName: (context) => LoginPage(),
          },
        ),
      ),
    );
  }
}
