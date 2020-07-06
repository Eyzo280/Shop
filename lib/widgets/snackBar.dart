import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/providers/cart.dart';

var buttonActive = true;

Widget snackBarProduct({
  BuildContext context,
  String productUid,
  String name,
  double price,
  int quantity,
}) {
  return SnackBar(
    backgroundColor: Color.fromRGBO(128, 0, 128, 0.5),
    content: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(name),
        Text('${price.toString()} \$'),
        Text('x ${quantity.toString()}'),
        RaisedButton(
          color: Theme.of(context).errorColor,
          onPressed: () {
            if (buttonActive) {
              // Zabezpieczenie gdyby ktos szybko kliknal kilka razy w przycisk.
              buttonActive = false;
              Provider.of<Cart>(context, listen: false).undoLastProducts(
                  productUid: productUid, removeQuantity: quantity);
              Scaffold.of(context).hideCurrentSnackBar();
              print('Undo');
              Future.delayed(Duration(seconds: 1)).then((value) {
                buttonActive = true;
              });
            }
          },
          child: Text('Undo'),
        ),
      ],
    ),
  );
}
