import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find/service/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class BuildDrawers extends StatefulWidget {
  @override
  _BuildDrawersState createState() => _BuildDrawersState();
}

class _BuildDrawersState extends State<BuildDrawers> {
  String currentId;

  void initState() {
    getLogedUser();
    getLogedUser();
    super.initState();
  }

  void getLogedUser() async {
    FirebaseUser loggedUser = await FirebaseAuth.instance.currentUser();
    if (loggedUser != null) {
      setState(() {
        currentId = loggedUser.uid;
        print(currentId);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthService _auth = AuthService();
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('users')
          .where('id', isEqualTo: currentId)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        return PageView(
          children: snapshot.data.documents.map((DocumentSnapshot document) {
            return Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(10),
              color: Colors.grey,
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(
                          'assets/bg.jpg',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(document['firstName'] != null ||
                              document['lastName'] != null
                          ? '${document['firstName']} ${document['lastName']}'
                          : 'Gest')
                    ],
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text("Home"),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                  ),
                  ListTile(
                    leading: Icon(Icons.dashboard),
                    title: Text("Dashboard"),
                    onTap: () => Navigator.of(context)
                        .pushReplacementNamed('/dashboard'),
                  ),
                  ListTile(
                    leading: Icon(Icons.category),
                    title: Text("Categories"),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                  ),
                  ListTile(
                    leading: Icon(Icons.info),
                    title: Text("About"),
                    onTap: () =>
                        Navigator.of(context).pushReplacementNamed('/'),
                  ),
                  ListTile(
                    leading: Icon(Icons.exit_to_app),
                    title: Text('logOut'),
                    onTap: () async {
                      await _auth.signOut();
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
