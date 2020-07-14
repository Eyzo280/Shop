import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/products.dart';
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/manage_products/myProduct.dart';

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
                      return Dismissible(
                        key: ValueKey(myProducts[index].uid),
                        background: Container(
                          color: Theme.of(context).errorColor,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 40,
                          ),
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.only(right: 20),
                          margin: EdgeInsets.symmetric(
                            horizontal: 15,
                            vertical: 4,
                          ),
                        ),
                        confirmDismiss: (_) {
                          return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Are you sure?'),
                                  content: Text(
                                    'Do you want to remove the item from the cart?',
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                    ),
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Provider.of<Products>(context,
                                                listen: false)
                                            .removeMyProduct(
                                                productUid:
                                                    myProducts[index].uid)
                                            .catchError((err) {
                                          setState(() {
                                            Navigator.of(context).pop(false);
                                            Scaffold.of(context)
                                                .hideCurrentSnackBar();
                                            Scaffold.of(context).showSnackBar(
                                              // nie dziala
                                              SnackBar(
                                                content: SizedBox(
                                                    height: 25,
                                                    child: Center(
                                                        child: Text(
                                                      'Problem from deleted this product.',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ))),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                    Radius.circular(20),
                                                  ),
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          });
                                        }).then((value) => Navigator.of(context)
                                                .pop(true));
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: MyProduct(index: index),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
