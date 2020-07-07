import 'package:flutter/material.dart';
import 'package:shopapp/widgets/drawer.dart';

class OrdersPage extends StatelessWidget {
  static const routeName = '/Orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        centerTitle: true,
      ),
      drawer: DrawerApp(),
      body: Column(
        children: <Widget>[
          Flexible(
            fit: FlexFit.tight,
            child: Row(
              children: <Widget>[
                Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text('data'),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: InkWell(
                        onTap: () {},
                        child: Center(
                          child: Text('data'),
                        ),
                      ),
                    ),
                  ),
                ),
                Flexible(
                  fit: FlexFit.tight,
                  child: InkWell(
                    onTap: () {},
                    child: Center(
                      child: Text('data'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(),
          Flexible(
            flex: 5,
            fit: FlexFit.tight,
            child: Text('data'),
          ),
        ],
      ),
    );
  }
}
