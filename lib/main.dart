import 'package:flutter/material.dart';
import 'package:shopapp/pages/login.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop App',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          textTheme: TextTheme(
            bodyText1: TextStyle(
              color: Colors.purple,
              fontWeight: FontWeight.bold,
            ),
          )),
      home: LoginPage(),
      initialRoute: '/',
      routes: {
        // LoginPage.routeName: (context) => LoginPage(),
      },
    );
  }
}
