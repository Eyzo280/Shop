import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail({
    @required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Image.network(product.imageUrl),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                child: Container(
                  width: double.infinity,
                  color: const Color.fromRGBO(0, 0, 0, 0.2),
                  child: Column(
                    children: <Widget>[
                      Flexible(
                        fit: FlexFit.tight,
                        child: Builder(builder: (BuildContext ctx) { // Builder byl potrzebny, aby mozna tu bylo uzywac SnackBar
                          return FlatButton(
                            onPressed: () {
                              Provider.of<Cart>(context, listen: false)
                                  .addItemToCart(ctx: ctx,productUid: product.uid, name: product.name, imageUrl: product.imageUrl, price: product.price);
                              
                              print('Add to cart');
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Text(
                                  '${product.price.toString()} \$',
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
                                ),
                                Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
                                ),
                                Icon(
                                  Icons.add_shopping_cart,
                                  color: Theme.of(context).buttonColor,
                                )
                              ],
                            ),
                          );
                        }),
                      ),
                      const Divider(),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                  'Noś na wakacje lub w weekend. Możesz także założyć je do skarpetek (o gustach się nie dyskutuje). Od lat 70. klapki adidas Adilette są kultowym modelem w stylu z 3 paskami. Ta wersja ma miękką gumową podeszwę i szybkoschnący górny pasek, który pozwoli przejść z szatni na promenadę.'),
                              RaisedButton(
                                onPressed: () {
                                  print('Buy Now');
                                },
                                elevation: 8,
                                textColor: Colors.white,
                                child: const Text('Buy Now'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
