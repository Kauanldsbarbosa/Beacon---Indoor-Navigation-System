import 'package:beacon/routes/routes.dart';
import 'package:flutter/material.dart';

class NavigationDrawerWidget extends StatefulWidget {
  const NavigationDrawerWidget({super.key});

  @override
  State<NavigationDrawerWidget> createState() => _NavigationDrawerWidgetState();
}

class _NavigationDrawerWidgetState extends State<NavigationDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
        const DrawerHeader(child: Text('Menu')),
        ...Routes.values.where((route) => route.showInDrawer).map((route) =>  ListTile(
          title: Text(route.name),
          onTap: () {
            Navigator.pushNamed(context, route.path);
          },
          trailing: Icon(route.icon),
        ))
        ],
      ),
    );
  }
}