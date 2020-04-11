import 'package:find/model/product.dart';
import 'package:find/service/database.dart';
import 'package:find/shared/constants.dart';
import 'package:flutter/material.dart';

class EditProductForm extends StatefulWidget {
  final String productId;
  EditProductForm({this.productId});
  @override
  _EditProductFormState createState() => _EditProductFormState();
}

class _EditProductFormState extends State<EditProductForm> {
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final DbService _db = DbService();
  final Map<String, dynamic> _formData = {
    'title': null,
    'desc': null,
    'isFav': false,
    'image': null,
    'price': null,
  };

  Widget _buildTitleFeild(title) {
    return TextFormField(
      initialValue: title,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter title';
        }
        return null;
      },
      onChanged: (value) => _formData['title'] = value,
      decoration:
          textInputDecoration.copyWith(hintText: 'title', labelText: 'title'),
    );
  }

  Widget _builddescFeild(desc) {
    return TextFormField(
      initialValue: desc,
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return 'Please enter First describtion';
        }
        return null;
      },
      onChanged: (value) => _formData['title'] = value,
      decoration:
          textInputDecoration.copyWith(hintText: 'title', labelText: 'title'),
    );
  }

  Widget _buildPriceFeild(double price) {
    return TextFormField(
      initialValue: price.toString(),
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value.toString().isEmpty) {
          return 'Please enter Last Name';
        }
        return null;
      },
      onChanged: (value) => _formData['price'] = value,
      decoration: textInputDecoration.copyWith(
          hintText: 'Last Name', labelText: 'Last Name'),
    );
  }

  Widget _buildSubmitButton(id, title, desc, price, isFave) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : RaisedButton(
            onPressed: () async {
              if (!_formKey.currentState.validate()) {
                return;
              }
              setState(() {
                _loading = true;
              });
              _formKey.currentState.save();
              await _db.updateProduct(
                widget.productId ?? id,
                _formData['title'] ?? title,
                _formData['desc'] ?? desc,
                _formData['price'] ?? price,
                _formData['isFav'] ?? false,
              );
              setState(() {
                _loading = false;
              });
              Navigator.of(context).pop();
            },
            child: Text(
              'Update',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Product>(
      stream: DbService(productId: widget.productId).productData,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          Product productData = snapshot.data;
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(10),
              color: Colors.black.withOpacity(0.9),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    _buildTitleFeild(productData.title),
                    SizedBox(
                      height: 20,
                    ),
                    _builddescFeild(productData.desc),
                    SizedBox(
                      height: 20,
                    ),
                    _buildPriceFeild(productData.price),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.indigo),
                        color: Colors.white,
                      ),
                      child: _buildSubmitButton(
                          productData.id,
                          productData.title,
                          productData.desc,
                          productData.price,
                          productData.isFav),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/bg.jpg'),
                  fit: BoxFit.fill,
                ),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                color: Colors.black.withOpacity(0.9),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: <Widget>[
                      _buildTitleFeild(_formData['title']),
                      SizedBox(
                        height: 20,
                      ),
                      _builddescFeild(_formData['desc']),
                      SizedBox(
                        height: 20,
                      ),
                      _buildPriceFeild(_formData['price']),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.indigo),
                          color: Colors.white,
                        ),
                        child: _buildSubmitButton(
                            _formData['id'],
                            _formData['title'],
                            _formData['desc'],
                            _formData['price'],
                            _formData['isFav']),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
