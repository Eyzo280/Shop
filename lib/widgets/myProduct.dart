import 'package:flutter/material.dart';
import 'package:shopapp/models/product.dart';

class MyProduct extends StatefulWidget {
  final Product product;

  MyProduct({this.product});

  @override
  _MyProductState createState() => _MyProductState();
}

class _MyProductState extends State<MyProduct> {
  bool _edit = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: SizedBox(
            height: 50,
            width: 50,
            child: Image.network(widget.product.imageUrl)),
        title: _edit
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Name:'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: widget.product.name),
                      maxLength: 15,
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Price:'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: widget.product.price.toString()),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 5),
                      child: Text('Description:'),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: widget.product.description,
                      ),
                      maxLines: null,
                      maxLength: 150,
                    ),
                    Center(
                      child: RaisedButton(
                        onPressed: () {
                          print('Save');
                        },
                        child: FittedBox(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.save, color: Colors.white,),
                              Text('Save', style: TextStyle(color: Colors.white),),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
            : Text(widget.product.name),
        subtitle: _edit ? SizedBox() : Text('Price: ${widget.product.price}'),
        trailing: IconButton(
          onPressed: () {
            setState(() {
              _edit = !_edit;
            });
            print('Edit');
          },
          icon: Icon(Icons.edit),
        ),
      ),
    );
  }
}
