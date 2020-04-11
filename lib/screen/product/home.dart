import 'package:find/model/product.dart';
import 'package:find/screen/product/products.dart';
import 'package:find/service/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Product>>.value(
      value: DbService().prodcuts,
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: Text('Products'),
          actions: <Widget>[
            RaisedButton(
              onPressed: () => Navigator.of(context).pushNamed('/add'),
            )
          ],
          backgroundColor: Colors.amber[400],
          elevation: 0.0,
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Products()),
      ),
    );
  }
}
