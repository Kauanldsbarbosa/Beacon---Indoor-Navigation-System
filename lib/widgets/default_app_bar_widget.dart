import 'package:flutter/material.dart';

class DefaultAppBarWidget extends StatefulWidget {
  const DefaultAppBarWidget({super.key});

  @override
  State<DefaultAppBarWidget> createState() => _DefaultAppBarWidgetState();
}

class _DefaultAppBarWidgetState extends State<DefaultAppBarWidget> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Beacon App'),
    );
  }
}