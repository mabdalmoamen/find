import 'package:find/shared/widget/drawer.dart';
import 'package:find/screen/users/build-card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Dashboard'),
          ),
          drawer: BuildDrawer(),
          body: Container(
            margin: EdgeInsets.only(bottom: 20, top: 20),
            child: Column(
              children: <Widget>[
                Container(
                  height: 200,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        constraints: BoxConstraints(maxWidth: 207),
                        child: BuildCard(
                          color: Colors.indigo,
                          icon: FontAwesomeIcons.solidEnvelope,
                          size: 150.0,
                          title: '3 Pending Message',
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 207),
                        child: BuildCard(
                          color: Colors.indigo,
                          icon: FontAwesomeIcons.commentDots,
                          size: 150.0,
                          title: '3 Pending Comments',
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 207),
                        child: BuildCard(
                          color: Colors.indigo,
                          icon: FontAwesomeIcons.users,
                          size: 150.0,
                          title: '10 Pending Members',
                        ),
                      ),
                      Container(
                        constraints: BoxConstraints(maxWidth: 207),
                        child: BuildCard(
                          color: Colors.indigo,
                          icon: FontAwesomeIcons.share,
                          size: 150.0,
                          title: '10 new Post',
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BuildCard(
                    color: Colors.indigo,
                    icon: FontAwesomeIcons.peopleArrows,
                    size: 150.0,
                    title: 'Manage Members',
                    width: MediaQuery.of(context).size.width - 10,
                    navFunc: () => Navigator.of(context).pushNamed('/users'),
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: BuildCard(
                        color: Colors.green,
                        icon: Icons.category,
                        size: 150.0,
                        title: 'Manage Categories',
                      ),
                    ),
                    Expanded(
                      child: BuildCard(
                        color: Colors.tealAccent,
                        icon: FontAwesomeIcons.productHunt,
                        size: 135.0,
                        title: 'Manage Products',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),

      //
    );
  }
}
