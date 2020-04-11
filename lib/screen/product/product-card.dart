import 'package:find/model/product.dart';
import 'package:find/service/auth.dart';
import 'package:find/shared/widget/edit-user-form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  ProductCard({this.product});
  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          color: Colors.indigo[200],
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Text('${widget.product.title}'),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return EditUser(
                          uid: widget.product.id,
                        );
                      },
                    );
                  },
                  icon: Icon(FontAwesomeIcons.edit),
                ),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Alert Dialog'),
                          content: Text(
                            'Are You sure Delteing ${widget.product.title}',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                await AuthService()
                                    .deleteUser(widget.product.id);
                                Navigator.of(context).pushNamed('/');
                              },
                            )
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.close),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
