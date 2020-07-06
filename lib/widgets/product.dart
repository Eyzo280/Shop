import 'package:flutter/material.dart';
import 'package:shopapp/models/product.dart';
import 'package:shopapp/widgets/product_detail.dart';

class ProductWidget extends StatelessWidget {
  final Product product;
  final deviceSize;

  ProductWidget({
    @required this.product,
    @required this.deviceSize,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return ProductDetail(
                createUid: product.createUid,
                description: product.description,
                imageUrl: product.imageUrl,
                name: product.name,
                price: product.price,
              );
            }));
            print('Product Detail');
          },
          child: Container(
            color: Colors.white,
            child: Image.network(product.imageUrl),
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
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${product.price} \$',
                    ),
                  ],
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                child: FlatButton(
                  onPressed: () {
                    print('Add new product');
                  },
                  child: const Icon(Icons.shopping_cart),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
