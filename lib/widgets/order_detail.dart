import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/widgets/slider_images.dart';

class OrderDetail extends StatelessWidget {
  final ProductFromOrder productFromOrder;
  final String orderDateOfPurchase;
  final String orderUid;

  OrderDetail({
    this.productFromOrder,
    this.orderDateOfPurchase,
    this.orderUid,
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
        title: Hero(
            tag: 'name' + productFromOrder.name + orderUid,
            child: Text(productFromOrder.name)),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: SliderImages(
                imagesToSliders: productFromOrder.imageUrls,
                productUrl: productFromOrder.imageUrls[0] + orderUid,
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
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Hero(
                                tag: productFromOrder.price.toString() +
                                    orderUid,
                                flightShuttleBuilder: flightShuttleBuilder,
                                child: Text(
                                  '${productFromOrder.price.toString()} \$',
                                  style: TextStyle(
                                      color: Theme.of(context).buttonColor),
                                ),
                              ),
                              FittedBox(
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'Date of purchase',
                                      style: TextStyle(
                                          color: Theme.of(context).buttonColor),
                                    ),
                                    Text(
                                      DateFormat('yyyy-MM-dd')
                                          .format(DateTime.parse(
                                              orderDateOfPurchase))
                                          .toString(),
                                      style: TextStyle(
                                          color: Theme.of(context).buttonColor),
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'x ${productFromOrder.quantity}',
                                style: TextStyle(
                                    color: Theme.of(context).buttonColor),
                              ),
                            ],
                          );
                        }),
                      ),
                      const Divider(),
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                              'Noś na wakacje lub w weekend. Możesz także założyć je do skarpetek (o gustach się nie dyskutuje). Od lat 70. klapki adidas Adilette są kultowym modelem w stylu z 3 paskami. Ta wersja ma miękką gumową podeszwę i szybkoschnący górny pasek, który pozwoli przejść z szatni na promenadę.'),
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
