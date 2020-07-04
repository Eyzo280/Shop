import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/auth.dart';

class Shop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _auth = Provider.of<Auth>(context);
    var user = Provider.of<User>(context);
    print(user.uid);
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.lock_outline), onPressed: _auth.signOut)
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [Colors.blue, Colors.purple],
              ),
            ),
        child: Text('Hello'),
      ),
    );
  }
}
