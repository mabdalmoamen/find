import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BuildCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final String title;
  final double width;
  final Function navFunc;
  BuildCard(
      {this.icon,
      this.color,
      this.size = 150.0,
      this.title,
      this.width = 197,
      this.navFunc});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        constraints: BoxConstraints(minWidth: 207),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: InkWell(
          onTap: navFunc,
          child: Stack(
            children: <Widget>[
              Container(
                  margin: EdgeInsets.only(bottom: 18),
                  alignment: Alignment.center,
                  child: FaIcon(icon, color: color, size: size + 10)),
              Positioned(
                bottom: 0,
                child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  width: width,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black.withOpacity(0.7)),
                  child: Text(
                    title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
