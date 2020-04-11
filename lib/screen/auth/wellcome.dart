import 'package:find/model/user.dart';
import 'package:find/screen/auth/login.dart';
import 'package:find/screen/product/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wellcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Login();
    } else {
      return Home();
    }
  }
}
