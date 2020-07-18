import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_picker/image_picker.dart';
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

  final picker = ImagePicker();
  List<String> addedImages = [];
  bool _isData = false;

  Product _editProduct = Product(
    uid: '',
    createUid: '',
    description: '',
    imageUrls: [],
    name: '',
    price: 0.0,
  );

  void showSnackBar(String type, Color color) {
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
          backgroundColor: color,
        ),
      );
      _loading = false;
      if (type != 'Error') {
        _edit = false;
      }
    });
  }

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
      if (_editProduct.uid == null) {
        await Provider.of<Products>(context, listen: false)
            .addNewMyProduct(product: _editProduct, userUid: userUid)
            .then((_) {
          widget.close();
          showSnackBar('Added new product.', Colors.green);
        });
      } else {
        await Provider.of<Products>(context, listen: false)
            .editMyProduct(product: _editProduct, userUid: userUid)
            .then((_) {
          showSnackBar('Saved', Colors.green);
        });
      }
    } catch (err) {
      showSnackBar('Error', Colors.red);
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
                imageUrls: addedImages,
                name: product.name,
                price: _editProduct.price,
              );
            } else {
              _editProduct = Product(
                uid: product.uid,
                createUid: product.createUid,
                description: _editProduct.description,
                imageUrls: addedImages,
                name: val,
                price: _editProduct.price,
              );
            }
          },
        )
      ],
    );
  }

  Widget images() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Images:'),
        Container(
          height: addedImages.length >= 3 ? 150 : 75,
          width: double.infinity,
          child: GridView.count(
            crossAxisCount: 3,
            children: List.generate(
              addedImages.isEmpty
                  ? 1
                  : addedImages.length == 6
                      ? 6
                      : addedImages.length +
                          1, // dodaje 1 do ilosci dodanych zdjęć, aby ikona dodawania była zawsze na końcu, oraz jeżeli jest 6 zdjęć to nie dodaje już 1.
              (index) {
                if (addedImages.isEmpty || addedImages.length == index) {
                  return IconButton(
                    icon: Icon(Icons.add_a_photo),
                    onPressed: () async {
                      final pickedFile =
                          await picker.getImage(source: ImageSource.gallery);
                      setState(() {
                        addedImages.add(pickedFile.path);
                        _editProduct = Product(
                          uid: _editProduct.uid,
                          createUid: _editProduct.createUid,
                          description: _editProduct.description,
                          imageUrls: addedImages,
                          name: _editProduct.name,
                          price: _editProduct.price,
                        );
                        print(addedImages);
                      });
                    },
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: <Widget>[
                        addedImages[index].toString().contains('https://')
                            ? Image.network(addedImages[index])
                            : Image.asset(addedImages[index]),
                        Positioned(
                          left: 20,
                          bottom: 20,
                          child: IconButton(
                            splashColor: Color.fromRGBO(0, 0, 0, 0),
                            highlightColor: Color.fromRGBO(0, 0, 0,
                                0), // wylaczona animacja prz naciskaniu przycisku
                            icon: Icon(
                              MaterialIcons.delete,
                              size: 20,
                              color: Theme.of(context).errorColor,
                            ),
                            onPressed: () {
                              setState(() {
                                addedImages.removeWhere(
                                    (element) => element == addedImages[index]);
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  );
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${addedImages.length} / 6',
              style: TextStyle(fontSize: 12.5, color: Colors.grey),
            ),
          ),
        )
      ],
    );
  }

  Widget price(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: const Text('Price:'),
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
                imageUrls: addedImages,
                name: _editProduct.name,
                price: product.price,
              );
            } else {
              _editProduct = Product(
                uid: product.uid,
                createUid: product.createUid,
                description: _editProduct.description,
                imageUrls: addedImages,
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
            border: const OutlineInputBorder(),
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
                imageUrls: addedImages,
                name: _editProduct.name,
                price: _editProduct.price,
              );
            } else {
              _editProduct = Product(
                uid: product.uid,
                createUid: product.createUid,
                description: val,
                imageUrls: addedImages,
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
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ))
                  : Row(
                      children: <Widget>[
                        Icon(
                          Icons.save,
                          color: Colors.white,
                        ),
                        const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
            ),
            disabledColor: const Color.fromRGBO(128, 0, 128, 0.8),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    addedImages.clear();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.index == null) {
      _edit = true;
    }

    var myProducts = Provider.of<Products>(context).myProducts;

    // Adds url image from database when start this page
    if (!_isData && (addedImages.isEmpty && widget.index != null)) {
      _isData = true;
      addedImages.addAll(myProducts[widget.index].imageUrls);
    }

    Product product = widget.index != null
        ? myProducts[widget.index]
        : Product(
            uid: null,
            createUid: null,
            description: '',
            imageUrls: [],
            name: '',
            price: 0.0,
          );

    var userUid = Provider.of<User>(context).uid;
    return Card(
      child: ListTile(
        leading: addedImages.isEmpty
            ? Image.asset('images/empty_url.png')
            : addedImages[0].toString().contains('https://')
                ? Image.network(addedImages[0])
                : Image.asset(addedImages[0]),
        title: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
          height: !_edit ? 20 : addedImages.length >= 3 ? 560 : 485,
          child: _edit
              ? SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          name(product),
                          images(),
                          price(product),
                          description(product),
                          saveButton(product, userUid),
                        ],
                      ),
                    ),
                  ),
                )
              : Text(product.name),
        ),
        subtitle: _edit ? const SizedBox() : Text('Price: ${product.price}'),
        trailing: IconButton(
          onPressed: widget.index == null
              ? () {
                  widget.close();
                  print('Close New Product');
                }
              : () {
                  setState(() {
                    if (_edit) {
                      addedImages.clear();

                      _isData = false;
                    }

                    _edit = !_edit;
                  });
                  print('Edit');
                },
          icon: widget.index == null
              ? const Icon(Icons.close)
              : const Icon(Icons.edit),
        ),
      ),
    );
  }
}
