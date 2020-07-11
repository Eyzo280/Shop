import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/product_detail.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final deviceSize;

  ProductWidget({
    @required this.product,
    @required this.deviceSize,
  });

  Widget flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProductDetail(
                product: product,
              );
            }));
            print('Product Detail');
          },
          child: Container(
            color: Colors.white,
            child: Hero(
              tag: product.imageUrl,
              child: Image.network(product.imageUrl),
            ),
          ),
        ),
        footer: Container(
          height: deviceSize.height * 0.05,
          color: const Color.fromRGBO(220, 220, 220, 0.75),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Hero(
                      tag: 'name' + product.uid,
                      flightShuttleBuilder: flightShuttleBuilder,
                                          child: Text(
                        product.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Hero(
                      tag: product.price,
                      flightShuttleBuilder: flightShuttleBuilder,
                      child: Text(
                        '${product.price} \$',
                      ),
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: FlatButton(
                  onPressed: () {
                    Provider.of<Cart>(context, listen: false).addItemToCart(
                        ctx: context,
                        productUid: product.uid,
                        name: product.name,
                        imageUrl: product.imageUrl,
                        decription: product.description,
                        price: product.price);
                    print('Add new product');
                  },
                  child: Hero(
                    tag: 'icon-' + product.uid,
                    child: const Icon(Icons.add_shopping_cart),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
