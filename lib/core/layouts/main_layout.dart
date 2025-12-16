import 'package:beacon/widgets/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';

class MainLayout extends StatefulWidget {
  final Widget child; 
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon App', style: TextStyle(color: colorScheme.onPrimary),),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: widget.child,
      drawer: const NavigationDrawerWidget(),
    );
  }
}