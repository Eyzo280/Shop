import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/products.dart';

class MyProduct extends StatefulWidget {
  final int index;

  MyProduct({this.index});

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  bool _edit = false;
  bool _loading = false;

  GlobalKey<FormState> _key = GlobalKey<FormState>();

  Product _editProduct = Product(
    uid: null,
    createUid: null,
    description: null,
    imageUrl: null,
    name: null,
    price: null,
  );

  void saveProduct() async {
    if (!_key.currentState.validate()) {
      return;
    }
    _key.currentState.save();
    _key.currentState.validate();

    setState(() {
      _loading = true;
    });

    try {
      await Provider.of<Products>(context, listen: false)
          .editMyProduct(product: _editProduct)
          .whenComplete(() {
        setState(() {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: SizedBox(
                  height: 25,
                  child: Center(
                      child: Text(
                    'Saved',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              backgroundColor: Colors.green,
            ),
          );
          _loading = false;
          _edit = false;
        });
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    var myProducts = Provider.of<Products>(context).myProducts;
    Product product = myProducts[widget.index];
    return Card(
      child: ListTile(
        leading: SizedBox(
            height: 50, width: 50, child: Image.network(product.imageUrl)),
        title: _edit
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Name:'),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.length > 15) {
                            return 'Name is too long.';
                          }
                          /*
                          if (val.isEmpty) {
                            return 'Name can\'t be empty.';
                          }
                          */

                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: product.name),
                        maxLength: 15,
                        maxLengthEnforced: false,
                        onSaved: (val) {
                          if (val.isEmpty) {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              name: product.name,
                              price: _editProduct.price,
                            );
                          } else {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              name: val,
                              price: _editProduct.price,
                            );
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Image Url:'),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return null;
                          }
                          if (!RegExp(
                                  r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+')
                              .hasMatch(val)) {
                            return 'Invalid url.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: product.imageUrl),
                        onSaved: (val) {
                          if (val.isEmpty) {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: product.description,
                              imageUrl: product.imageUrl,
                              name: _editProduct.name,
                              price: _editProduct.price,
                            );
                          } else {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: _editProduct.description,
                              imageUrl: val,
                              name: _editProduct.name,
                              price: _editProduct.price,
                            );
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Price:'),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.isEmpty) {
                            return null;
                          }
                          if (!RegExp(r'[0-9]').hasMatch(val)) {
                            return 'Only Number.';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: product.price.toString() + ' \$',
                        ),
                        keyboardType: TextInputType.number,
                        onSaved: (val) {
                          if (val.isEmpty) {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              name: _editProduct.name,
                              price: product.price,
                            );
                          } else {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: _editProduct.description,
                              imageUrl: _editProduct.imageUrl,
                              name: _editProduct.name,
                              price: double.parse(val),
                            );
                          }
                        },
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child: Text('Description:'),
                      ),
                      TextFormField(
                        validator: (val) {
                          if (val.length <= 150) {
                            return null;
                          }
                          return 'Description is too long.';
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: product.description,
                        ),
                        maxLines: null,
                        maxLength: 150,
                        maxLengthEnforced: false,
                        onSaved: (val) {
                          if (val.isEmpty) {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: product.description,
                              imageUrl: _editProduct.imageUrl,
                              name: _editProduct.name,
                              price: _editProduct.price,
                            );
                          } else {
                            _editProduct = Product(
                              uid: product.uid,
                              createUid: product.createUid,
                              description: val,
                              imageUrl: _editProduct.imageUrl,
                              name: _editProduct.name,
                              price: _editProduct.price,
                            );
                          }
                        },
                      ),
                      Center(
                        child: RaisedButton(
                          onPressed: _loading
                              ? null
                              : () {
                                  _key.currentState.validate();
                                  saveProduct();
                                  print('Save');
                                },
                          child: FittedBox(
                            child: _loading
                                ? SizedBox(
                                    height: 25,
                                    width: 25,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ))
                                : Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.save,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                          ),
                          disabledColor: Color.fromRGBO(128, 0, 128, 0.8),
                        ),
                      )
                    ],
                  ),
                ),
              )
            : Text(product.name),
        subtitle: _edit ? SizedBox() : Text('Price: ${product.price}'),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _edit = !_edit;
            });
            print('Edit');
          },
          icon: Icon(Icons.edit),
        ),
      ),
    );
  }
}
