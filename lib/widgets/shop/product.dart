import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/shop/product_detail.dart';

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
              return BlocProvider<QuantityProduct>(
                create: (BuildContext context) => QuantityProduct(),
                child: ProductDetail(
                  product: product,
                ),
              );
            }));
            print('Product Detail');
          },
          child: Container(
            color: Colors.white,
            child: Hero(
              tag: product.imageUrls.isEmpty
                  ? '${product.uid}-Image'
                  : product.imageUrls[0],
              child: product.imageUrls.isEmpty
                  ? Image.asset('images/empty_url.png', fit:  BoxFit.fitHeight,)
                  : product.imageUrls[0].toString().contains('https://')
                      ? Image.network(product.imageUrls[0], fit:  BoxFit.fitHeight)
                      : Image.asset(product.imageUrls[0], fit:  BoxFit.fitHeight),
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
                      imageUrls: product.imageUrls,
                      decription: product.description,
                      price: product.price,
                      quantity: 1,
                      snackBar: true,
                    );
                    print('Add new product');
                  },
                  child: const Icon(Icons.add_shopping_cart),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
