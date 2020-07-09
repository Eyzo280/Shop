import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/products.dart';

class MyProduct extends StatefulWidget {
  final int index;
  final Function close;

  MyProduct({this.index, this.close});

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

  void saveProduct(userUid) async {
    if (!_key.currentState.validate()) {
      return;
    }
    _key.currentState.save();
    _key.currentState.validate();

    setState(() {
      _loading = true;
    });

    try {
      void showSnackBar(String type) {
        setState(() {
          Scaffold.of(context).hideCurrentSnackBar();
          Scaffold.of(context).showSnackBar(
            SnackBar(
              content: SizedBox(
                  height: 25,
                  child: Center(
                      child: Text(
                    type,
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
      }

      if (_editProduct.uid == null) {
        await Provider.of<Products>(context, listen: false)
            .addNewMyProduct(product: _editProduct, userUid: userUid)
            .whenComplete(() {
          widget.close();
          showSnackBar('Added new product.');
        });
      } else {
        await Provider.of<Products>(context, listen: false)
            .editMyProduct(product: _editProduct)
            .whenComplete(() {
          showSnackBar('Saved');
        });
      }
    } catch (err) {
      print(err);
    }
  }

  Widget name(Product product) {
    return Column(
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
            if (widget.index == null && val.isEmpty) {
              return 'Enter name.';
            }
            /*
                          if (val.isEmpty) {
                            return 'Name can\'t be empty.';
                          }
                          */

            return null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: product.name),
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
        )
      ],
    );
  }

  Widget imageUrl(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('Image Url:'),
        ),
        TextFormField(
          validator: (val) {
            if (val.isEmpty && widget.index != null) {
              return null;
            }
            if (!RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+')
                .hasMatch(val)) {
              return 'Invalid url.';
            }
            if (widget.index == null && val.isEmpty) {
              return 'Enter image url.';
            }
            return null;
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(), hintText: product.imageUrl),
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
      ],
    );
  }

  Widget price(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('Price:'),
        ),
        TextFormField(
          validator: (val) {
            if (val.isEmpty && widget.index != null) {
              return null;
            }
            if (!RegExp(r'[0-9]').hasMatch(val)) {
              return 'Only Number.';
            }
            if (widget.index == null && val.isEmpty) {
              return 'Enter price.';
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
      ],
    );
  }

  Widget description(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Text('Description:'),
        ),
        TextFormField(
          validator: (val) {
            if (val.length > 150) {
              return 'Description is too long.';
            }
            if (widget.index == null && val.isEmpty) {
              return 'Enter description.';
            }
            return null;
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
      ],
    );
  }

  Widget saveButton(Product product, String userUid) {
    return Column(
      children: <Widget>[
        Center(
          child: RaisedButton(
            onPressed: _loading
                ? null
                : () {
                    _key.currentState.validate();
                    saveProduct(userUid);
                    print('Save');
                  },
            child: FittedBox(
              child: _loading
                  ? SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
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
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == null) {
      _edit = true;
    }

    var myProducts = Provider.of<Products>(context).myProducts;
    Product product = widget.index != null
        ? myProducts[widget.index]
        : Product(
            uid: null,
            createUid: null,
            description: '',
            imageUrl: '',
            name: '',
            price: 0.0,
          );

    var userUid = Provider.of<User>(context).uid;
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
                      name(product),
                      imageUrl(product),
                      price(product),
                      description(product),
                      saveButton(product, userUid),
                    ],
                  ),
                ),
              )
            : Text(product.name),
        subtitle: _edit ? SizedBox() : Text('Price: ${product.price}'),
        trailing: IconButton(
          onPressed: widget.index == null
              ? () {
                  widget.close();
                  print('Close New Product');
                }
              : () {
                  setState(() {
                    _edit = !_edit;
                  });
                  print('Edit');
                },
          icon: widget.index == null ? Icon(Icons.close) : Icon(Icons.edit),
        ),
      ),
    );
  }
}
