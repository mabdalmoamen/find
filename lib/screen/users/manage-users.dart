import 'package:find/model/user.dart';
import 'package:find/screen/users/users.dart';
import 'package:find/service/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageUsers extends StatelessWidget {
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<UserData>>.value(
      value: AuthService().users,
      child: Scaffold(
        backgroundColor: Colors.amber[50],
        appBar: AppBar(
          title: Text('Users'),
          backgroundColor: Colors.amber[400],
          elevation: 0.0,
          actions: <Widget>[
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FlatButton(
                    child: Icon(Icons.exit_to_app),
                    onPressed: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Users()),
      ),
    );
  }
}
