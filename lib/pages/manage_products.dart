import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/myProduct.dart';

class ManageProducts extends StatefulWidget {
  static const routeName = '/ManageProducts';

  @override
  _ManageProductsState createState() => _ManageProductsState();
}

class _ManageProductsState extends State<ManageProducts> {
  bool _loading = true;
  bool _isData = false;
  bool _addNew = false;

  @override
  void didChangeDependencies() {
    if (!_isData) {
      String userUid = Provider.of<User>(context, listen: false).uid;
      Provider.of<Products>(context, listen: false)
          .fetchMyProducts(userUid: userUid)
          .whenComplete(() {
        setState(() {
          _loading = false;
        });
      });
    } else {
      setState(() {
        _loading = false;
      });
    }

    super.didChangeDependencies();
  }

  void _newProductClose() {
    setState(() {
      _addNew = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var myProducts = Provider.of<Products>(context).myProducts;
    print(myProducts);
    return Scaffold(
      appBar: AppBar(
        title: Text('ManageProducts'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                setState(() {
                  _addNew = true;
                });
                print('Add new Product');
              })
        ],
      ),
      drawer: DrawerApp(),
      body: _loading
          ? CircularProgressIndicator()
          : Column(
              children: <Widget>[
                !_addNew
                    ? SizedBox()
                    : Expanded(
                        child: SingleChildScrollView(
                            child: MyProduct(
                                index: null, close: _newProductClose))),
                Expanded(
                  child: ListView.builder(
                      itemCount: myProducts.length,
                      itemBuilder: (context, index) {
                        return MyProduct(index: index);
                      }),
                ),
              ],
            ),
    );
  }
}
