import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/repositories/beacon_repository.dart';
import 'package:beacon/widgets/beacon/beacon_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreviousBeaconsPage extends StatefulWidget {
  const PreviousBeaconsPage({super.key});

  @override
  State<PreviousBeaconsPage> createState() => _PreviousBeaconsPageState();
}

class _PreviousBeaconsPageState extends State<PreviousBeaconsPage> {
  List<Beacon> beacons = [];

  Future<List<Beacon>> get getBeacons async {
    final provider = context.read<BeaconProvider>();
    return await BeaconRepository(isar: provider.beaconRepository.isar).getAllBeacons();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.all(16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Previous Beacons',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        FutureBuilder(future: getBeacons, builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || (snapshot.data as List<Beacon>).isEmpty) {
            return const Center(child: Text('No beacons found.'));
          } else {
            final beacons = snapshot.data as List<Beacon>;
            return Expanded(child: BeaconListWidget(beacons: beacons));
          }
        })
      ],
    ));
  }
}