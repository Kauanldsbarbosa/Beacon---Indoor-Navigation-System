import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/widgets/beacon/beacon_card_widget.dart';
import 'package:flutter/material.dart';

class BeaconListWidget extends StatefulWidget {
  final List<Beacon> beacons;
  const BeaconListWidget({super.key, required this.beacons});

  @override
  State<BeaconListWidget> createState() => _BeaconListWidgetState();
}

class _BeaconListWidgetState extends State<BeaconListWidget> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.beacons.length,
      itemBuilder: (context, index) {
        return BeaconCardWidget(beacon:widget.beacons[index]);
      },
    );
  }
}