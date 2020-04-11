import 'dart:convert';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/model/product.dart';

class DbService {
  String productId;
  DbService({this.productId});
  // collection reference
  String userId;
  String userEmail;
  void getLogedUser() async {
    FirebaseUser loggedUser = await FirebaseAuth.instance.currentUser();
    if (loggedUser != null) {
      userId = loggedUser.uid;
      userEmail = loggedUser.email;
    }
  }

  final CollectionReference productCollction =
      Firestore.instance.collection('products');
  Future<Map<String, dynamic>> uploadImage(File image,
      {String imagePath}) async {
    final mimeTypeData = lookupMimeType(image.path).split('/');
    final imgUploadReq = http.MultipartRequest(
        'POST',
        Uri.parse(
            'https://us-central1-products-74d98.cloudfunctions.net/storeImage'));
    final file = await http.MultipartFile.fromPath(
      'image',
      image.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );
    imgUploadReq.files.add(file);
    if (imagePath != null) {
      imgUploadReq.fields['imagePath'] = Uri.encodeComponent(imagePath);
    }
    imgUploadReq.headers['Authorization'] = 'Bearer ';
    try {
      final streamResponse = await imgUploadReq.send();
      final response = await http.Response.fromStream(streamResponse);
      if (response.statusCode != 200 && response.statusCode != 201) {
        print('SomeThing went Wrong');
        print(json.encode(response.body));
        return null;
      }
      final responseData = json.decode(response.body);
      return responseData;
    } catch (error) {
      print(error);
      return null;
    }
  }

  Future<void> setProductData(String productId, String title, String desc,
      double price, String author, bool haveSale, File image) async {
    final uploadData = await uploadImage(image);
    if (uploadData == null) {
      print('upload Failed');
      return false;
    }
    return await productCollction.document(productId).setData({
      'title': title,
      'desc': desc,
      'price': price,
      'imagePath': uploadData['imagePath'],
      'imageUrl': uploadData['imageUrl'],
      'userEmail': userEmail,
      'userId': userId
    });
  }

  Future<void> updateProduct(String productId, String title, String desc,
      double price, bool haveSale) async {
    return await productCollction.document(productId).updateData({
      'productId': productId,
      'title': title,
      'desc': desc,
      'price': price,
      'userEmail': userEmail,
      'userId': userId
    });
  }

  Future<void> deleteProduct(productId) async {
    await productCollction.document(productId).delete();
  }

  // prodcuts list from snapshot
  List<Product> _productListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      print(doc.data);
      return Product(
        id: doc.data['productId'],
        title: doc.data['title'],
        desc: doc.data['desc'],
        price: doc.data['price'],
        userId: doc.data['author'],
        image: doc.data['image'],
        imagePath: doc.data['imagePath'],
        userEmail: doc.data['userEmail'],
        isFav: doc.data['isFav'],
      );
    }).toList();
  }

  // Product data from snapshots
  Product _productDataFromSnapshot(DocumentSnapshot doc) {
    return Product(
      id: doc.data['productId'],
      title: doc.data['title'],
      desc: doc.data['desc'],
      price: doc.data['price'],
      userId: doc.data['author'],
      image: doc.data['image'],
      imagePath: doc.data['imagePath'],
      userEmail: doc.data['userEmail'],
      isFav: doc.data['isFav'],
    );
  }

  // get prodcuts stream
  Stream<List<Product>> get prodcuts {
    return productCollction.snapshots().map(_productListFromSnapshot);
  }

  // get product doc stream
  Stream<Product> get productData {
    return productCollction
        .document(productId)
        .snapshots()
        .map(_productDataFromSnapshot);
  }

  Stream get singleProduct {
    return productCollction
        .document(productId)
        .snapshots()
        .map(_productDataFromSnapshot);
  }
}
