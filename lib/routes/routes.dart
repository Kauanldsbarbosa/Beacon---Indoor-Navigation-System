import 'package:flutter/material.dart';

enum Routes {
  activeBeacons(
    path: '/activeBeacons',
    label: 'Beacons Ativos',
    icon: Icons.radar,
    showInDrawer: true
  ),
  previousBeacons(
    path: '/previousBeacons',
    label: 'Beacons Anteriores',
    icon: Icons.history,
    showInDrawer: true
  ),
  roomPage(
    path: '/roomPage',
    label: 'Room Page',
    icon: Icons.room,
    showInDrawer: true
  ),
  roomInspectPage(
    path: '/room/inspect',
    label: 'Room Detail Page',
    icon: Icons.room_preferences,
    showInDrawer: false
  ),
  navigationPage(
    path: '/navigationPage',
    label: 'Navigation Page',
    icon: Icons.navigation,
    showInDrawer: false
  );

  final String path;
  final String label;
  final IconData icon;
  final bool showInDrawer;
  const Routes({
    required this.path,
    required this.label,
    required this.icon,
    this.showInDrawer = true,
  });
}