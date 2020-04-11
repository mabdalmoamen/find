import 'package:find/screen/users/manage-users.dart';
import 'package:find/shared/widget/edit-productform.dart';
import 'model/user.dart';
import 'package:find/screen/dashboard.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'screen/auth/wellcome.dart';
import 'service/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserModel>.value(
      value: AuthService().user,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          "/": (context) => Wellcome(),
          "/dashboard": (context) => Dashboard(),
          "/users": (context) => ManageUsers(),
          "/add": (context) => EditProductForm(),
        },
      ),
    );
  }
}
