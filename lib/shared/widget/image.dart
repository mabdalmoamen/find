import 'package:find/model/product.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImageInput extends StatefulWidget {
  final Function setImage;
  final Product product;
  ImageInput(this.setImage, this.product);
  @override
  _ImageInputState createState() => _ImageInputState();
}

class _ImageInputState extends State<ImageInput> {
  File _imgFile;

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      setState(() {
        _imgFile = image;
      });
      widget.setImage(image);
      Navigator.pop(context);
    });
  }

  void _openImgPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            height: 200,
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                Text(
                  'Pick Image',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  child: Text(
                    'Use Camera',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.purple,
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                FlatButton(
                  child: Text(
                    'Use Gallery',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  textColor: Colors.purple,
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Widget prevImg = Text('Please Select Image.');
    if (_imgFile != null) {
      prevImg = Image.file(
        _imgFile,
        fit: BoxFit.contain,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    } else if (widget.product != null) {
      prevImg = Image.network(
        widget.product.image,
        fit: BoxFit.contain,
        height: 300.0,
        alignment: Alignment.topCenter,
        width: MediaQuery.of(context).size.width,
      );
    }
    return Column(
      children: <Widget>[
        OutlineButton(
          borderSide: BorderSide(
            color: Colors.amber,
            width: 2.0,
          ),
          onPressed: () {
            _openImgPicker(context);
          },
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.camera),
                SizedBox(
                  width: 10.0,
                ),
                Text('Add Image')
              ]),
        ),
        SizedBox(
          height: 10.0,
        ),
        prevImg,
      ],
    );
  }
}
