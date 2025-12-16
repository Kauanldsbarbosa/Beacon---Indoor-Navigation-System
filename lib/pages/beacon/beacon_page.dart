import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/widgets/beacon/beacon_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BeaconPage extends StatefulWidget {
  const BeaconPage({super.key});

  @override
  State<BeaconPage> createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  @override
  Widget build(BuildContext context) {
    final beaconProvider = context.watch<BeaconProvider>();
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Beacons Ativos', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16.0),
          Expanded(
            child: BeaconListWidget(beacons: beaconProvider.beaconsInMemory),
          ),
        ],
      ),
    );
  }
}
