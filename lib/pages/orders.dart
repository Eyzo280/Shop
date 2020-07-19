import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/models/user.dart';
import 'package:shopapp/providers/orders.dart';
import 'package:shopapp/widgets/drawer.dart';
import 'package:shopapp/widgets/order.dart';

class OrdersPage extends StatefulWidget {
  static const routeName = '/Orders';

  @override
  _OrdersPageState createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  String filter = 'All';

  bool _isLoading = true;
  bool _isData = false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (!_isData) {
      var userUid = Provider.of<User>(context).uid;
      Provider.of<Orders>(context, listen: false)
          .fetchOrders(userUid: userUid)
          .whenComplete(() {
        setState(() {
          _isData = true;
          _isLoading = false;
        });
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      drawer: DrawerApp(),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: const [Colors.blue, Colors.purple],
          ),
        ),
        child: Column(
          children: <Widget>[
            Flexible(
              fit: FlexFit.tight,
              child: Card(
                child: Row(
                  children: <Widget>[
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            filter = 'All';
                          });
                        },
                        child: Container(
                          color: filter == 'All'
                              ? Color.fromRGBO(0, 0, 0, 0.2)
                              : Color.fromRGBO(0, 0, 0, 0),
                          child: Center(
                            child: Text('All'),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                filter = 'Paided';
                              });
                            },
                            child: Container(
                              color: filter == 'Paided'
                                  ? Color.fromRGBO(0, 0, 0, 0.3)
                                  : Color.fromRGBO(0, 0, 0, 0),
                              child: Center(
                                child: Text('Paided'),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      fit: FlexFit.tight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            filter = 'Finished';
                          });
                        },
                        child: Container(
                          color: filter == 'Finished'
                              ? Color.fromRGBO(0, 0, 0, 0.3)
                              : Color.fromRGBO(0, 0, 0, 0),
                          child: Center(
                            child: Text('Finished'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Divider(),
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: !_isData
                  ? SizedBox(
                      height: 50,
                      width: 50,
                      child: FittedBox(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Consumer<Orders>(
                      builder: (context, orders, _) {
                        return ListView.builder(
                          itemCount: filter == 'Paided'
                              ? orders.ordersPaided.length
                              : filter == 'Finished'
                                  ? orders.ordersFinished.length
                                  : orders.orders.length,
                          itemBuilder: (context, index) {
                            if (filter == 'Paided') {
                              return Order(
                                orderUid: orders.ordersPaided[index].uid,
                              );
                            } else if (filter == 'Finished') {
                              return Order(
                                orderUid: orders.ordersFinished[index].uid,
                              );
                            } else {
                              return Order(
                                orderUid: orders.orders[index].uid,
                              );
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
