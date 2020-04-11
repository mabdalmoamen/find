import 'package:find/shared/widget/build-drawer.dart';
import 'package:flutter/material.dart';

class BuildDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: Drawer(
        child: BuildDrawers(),
      ),
    );
  }
}
