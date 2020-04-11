import 'package:find/model/user.dart';
import 'package:find/screen/users/user-card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Users extends StatefulWidget {
  @override
  _UsersState createState() => _UsersState();
}

class _UsersState extends State<Users> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<UserData>>(context) ?? [];
    return ListView.builder(
      itemCount: users.length,
      itemBuilder: (context, index) {
        return Container(child: UserCard(user: users[index]));
      },
    );
  }
}
