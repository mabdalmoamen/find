import 'package:find/model/product.dart';
import 'package:find/screen/product/product-card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Products extends StatefulWidget {
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<List<Product>>(context) ?? [];
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return Container(child: ProductCard(product: products[index]));
      },
    );
  }
}
