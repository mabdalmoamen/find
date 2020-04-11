import 'package:find/model/user.dart';
import 'package:find/service/auth.dart';
import 'package:find/shared/widget/edit-user-form.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserCard extends StatefulWidget {
  final UserData user;
  UserCard({this.user});
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Card(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          color: Colors.indigo[200],
          child: Row(
            children: <Widget>[
              Expanded(
                flex: 8,
                child: Text('${widget.user.firstName} ${widget.user.lastName}'),
              ),
              Expanded(
                flex: 1,
                child: IconButton(
                  onPressed: () {
                    showBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return EditUser(
                          uid: widget.user.uid,
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
                            'Are You sure Delteing ${widget.user.firstName} ${widget.user.lastName}',
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('Delete'),
                              onPressed: () async {
                                await AuthService().deleteUser(widget.user.uid);
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
              !widget.user.isAdmin
                  ? Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: () async {
                          await AuthService()
                              .updateUserToAdmin(widget.user.uid);
                        },
                        icon: Icon(
                          Icons.verified_user,
                          color:
                              widget.user.isAdmin ? Colors.indigo : Colors.red,
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
