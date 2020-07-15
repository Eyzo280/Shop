import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/cart.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/product_detail.dart';

class CartListProducts extends StatefulWidget {
  final List<CartItem> cartProducts;

  CartListProducts({this.cartProducts, Key key}) : super(key: key);

  @override
  _CartListProductsState createState() => _CartListProductsState();
}

class _CartListProductsState extends State<CartListProducts>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _opacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
      flex: 5,
      fit: FlexFit.tight,
      child: ListView.builder(
          itemCount: widget.cartProducts.length,
          itemBuilder: (context, index) {
            return FadeTransition(
              opacity: _opacityAnimation,
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListTile(
                      onTap: () {
                        // Mozna przerobic na Routes
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return ProductDetail(
                            product: Product(
                                createUid: '',
                                description:
                                    widget.cartProducts[index].decription,
                                name: widget.cartProducts[index].name,
                                price: widget.cartProducts[index].price,
                                imageUrls: widget.cartProducts[index].imageUrls,
                                uid: widget.cartProducts[index].uid),
                          );
                        }));
                        print('Detail');
                      },
                      leading:
                          Image.network(widget.cartProducts[index].imageUrls[0]),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Text(widget.cartProducts[index].name),
                          Text('Count: ${widget.cartProducts[index].quantity}')
                        ],
                      ),
                      trailing: IconButton(
                          icon: Icon(
                            MaterialCommunityIcons.cart_minus,
                            color: Theme.of(context).errorColor,
                          ),
                          onPressed: () {
                            Provider.of<Cart>(context, listen: false)
                                .removeProductFromCart(
                                    productUid: widget.cartProducts[index].uid,
                                    removeQuantity: 1);
                          }),
                    ),
                  ),
                  Divider(),
                ],
              ),
            );
          }),
    );
  }
}
