import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/order.dart' as modelOrder;
import 'package:shopapp/models/product.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/order_detail.dart';

class Order extends StatefulWidget {
  final orderUid;

  Order({this.orderUid});

  @override
  _OrderState createState() => _OrderState();
}

class _OrderState extends State<Order> {
  bool open = false;
  bool isData = false;

  @override
  Widget build(BuildContext context) {
    modelOrder.Order order = Provider.of<Orders>(context, listen: false)
        .orders
        .where((element) => element.uid == widget.orderUid)
        .toList()[0];
    List<ProductFromOrder> products =
        Provider.of<Orders>(context).productsFormOrder[widget.orderUid];
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
      height: !open
          ? 65
          : products.length <= 3
              ? (double.parse(products.length.toString()) * 75) + 65
              : 290,
      child: Card(
        child: Column(
          children: <Widget>[
            ListTile(
              onTap: () {
                if (!isData) {
                  String userUid =
                      Provider.of<User>(context, listen: false).uid;
                  Provider.of<Orders>(context, listen: false)
                      .fetchProductFromOrder(
                          userUid: userUid, orderUid: widget.orderUid)
                      .whenComplete(() {
                    setState(() {
                      isData = true;
                      open = !open;
                    });
                  });
                } else {
                  setState(() {
                    open = !open;
                  });
                }

                print('Show all products');
              },
              leading: Text(
                DateTime.fromMillisecondsSinceEpoch(
                            DateTime.now().millisecondsSinceEpoch -
                                DateTime.parse(order.dateOfPurchase)
                                    .millisecondsSinceEpoch)
                        .day
                        .toString() +
                    ' days ago',
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text('Total price: ${order.totalPrice} \$'),
                  Column(
                    children: <Widget>[
                      Text('Status:'),
                      Text(order.delivery ? 'Zakonczona' : 'W drodze'),
                    ],
                  )
                ],
              ),
              trailing: open
                  ? Icon(Icons.arrow_drop_down)
                  : Icon(Icons.arrow_drop_up),
            ),
            !open
                ? SizedBox()
                : Expanded(
                    child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return OrderDetail(
                                    productFromOrder: products[index],
                                    orderDateOfPurchase: order.dateOfPurchase,
                                    orderUid: widget.orderUid,
                                  );
                                },
                              ),
                            );
                            print('Detail Order');
                          },
                          leading: Hero(
                            tag: '${products[index].imageUrls[0]}${widget.orderUid}-Image',
                            child: Image.network(products[index].imageUrls[0],width: 50,)),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              Text(products[index].name),
                              Text('${products[index].price} \$')
                            ],
                          ),
                          trailing: Text('x ${products[index].quantity}'),
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
