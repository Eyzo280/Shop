import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/providers/cart.dart';
import 'package:shopapp/widgets/slider_images.dart';

enum QuantityEvent { increment, decrement }

class QuantityProduct extends Bloc<QuantityEvent, int> {
  QuantityProduct() : super(1);

  @override
  Stream<int> mapEventToState(QuantityEvent event) async* {
    switch (event) {
      case QuantityEvent.decrement:
        yield state - 1;
        break;
      case QuantityEvent.increment:
        yield state + 1;
        break;
    }
  }
}

class ProductDetail extends StatelessWidget {
  final Product product;

  ProductDetail({
    @required this.product,
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
    return Scaffold(
      appBar: AppBar(
        title: Hero(tag: 'name' + product.uid, child: Text(product.name)),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: SliderImages(
                imagesToSliders: product.imageUrls,
                productUrl: product.imageUrls[0],
              ),
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
                        child: Builder(builder: (BuildContext ctx) {
                          // Builder byl potrzebny, aby mozna tu bylo uzywac SnackBar
                          return BlocBuilder<QuantityProduct, int>(
                              builder: (context, count) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                Hero(
                                  tag: product.price,
                                  flightShuttleBuilder: flightShuttleBuilder,
                                  child: Text(
                                    '${product.price.toString()} \$',
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor),
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.remove),
                                      onPressed: count <= 1
                                          ? null
                                          : () => context
                                              .bloc<QuantityProduct>()
                                              .add(QuantityEvent.decrement),
                                    ),
                                    Text(
                                      count.toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).buttonColor),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.add),
                                      onPressed: () => context
                                          .bloc<QuantityProduct>()
                                          .add(QuantityEvent.increment),
                                    )
                                  ],
                                ),
                                IconButton(
                                  onPressed: () {
                                    Provider.of<Cart>(context, listen: false)
                                        .addItemToCart(
                                      ctx: ctx,
                                      productUid: product.uid,
                                      name: product.name,
                                      imageUrls: product.imageUrls,
                                      decription: product.description,
                                      price: product.price,
                                      quantity: count,
                                      snackBar: true,
                                    );

                                    print('Add to cart');
                                  },
                                  icon: Icon(Icons.add_shopping_cart),
                                  color: Theme.of(context).buttonColor,
                                ),
                              ],
                            );
                          });
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
                                  product.description),
                              BlocBuilder<QuantityProduct, int>(
                                  builder: (ctx, count) {
                                return RaisedButton(
                                  onPressed: () {
                                    Provider.of<Cart>(context, listen: false)
                                        .addItemToCart(
                                      ctx: ctx,
                                      productUid: product.uid,
                                      name: product.name,
                                      imageUrls: product.imageUrls,
                                      decription: product.description,
                                      price: product.price,
                                      quantity: count,
                                      snackBar: false,
                                    );
                                    Navigator.pushReplacementNamed(
                                        context, '/Cart');
                                    print('Buy Now');
                                  },
                                  elevation: 8,
                                  textColor: Colors.white,
                                  child: const Text('Buy Now'),
                                );
                              }),
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
