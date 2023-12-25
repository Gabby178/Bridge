import 'package:flutter/material.dart';
import 'package:thebridges/myListTile.dart';

class MyDrawer extends StatelessWidget {
  final void Function()? onProfiletap;
  final void Function()? onsignoutap;
  const MyDrawer({
    super.key,
    required this.onProfiletap,
    required this.onsignoutap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        children: [
          //header
          DrawerHeader(
            child: Icon(
              Icons.person,
              color: Colors.white,
              size: 64,
            ),
          ),

          //drawe listtile
          MyListTile(
            icon: Icons.home,
            text: 'H O M E',
            ontap: () => Navigator.pop(context),
          ),

          MyListTile(
            icon: Icons.home,
            text: 'P R O F I L E',
            ontap: onProfiletap,
          ),

          MyListTile(
            icon: Icons.home,
            text: 'L O G O U T',
            ontap: onsignoutap,
          ),
        ],
      ),
    );
  }
}
