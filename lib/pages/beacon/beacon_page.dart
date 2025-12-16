import 'dart:async';

import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/widgets/beacon/beacon_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class BeaconPage extends StatefulWidget {
  const BeaconPage({super.key});

  @override
  State<BeaconPage> createState() => _BeaconPageState();
}

class _BeaconPageState extends State<BeaconPage> {
  late final StreamSubscription<BluetoothAdapterState> _btSubscription;
  
  bool loadingMemoryBeacons = false;

  @override
  void initState() {
    super.initState();

    _btSubscription = FlutterBluePlus.adapterState.listen((state) {
      if (state == BluetoothAdapterState.on) {
        _onBluetoothTurnedOn();
      }
    });


  }

  @override
  void dispose() {
    _btSubscription.cancel();
    super.dispose();
  }

  void _onBluetoothTurnedOn() {
    final beaconProvider = context.read<BeaconProvider>();

    beaconProvider.startBeacon();
  }

  @override
  Widget build(BuildContext context) {
    final beaconProvider = Provider.of<BeaconProvider>(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return StreamBuilder<BluetoothAdapterState>(
        stream: FlutterBluePlus.adapterState,
        initialData: BluetoothAdapterState.unknown,
        builder: (context, snapshot) {
          if (snapshot.data != BluetoothAdapterState.on) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Bluetooth está desligado. Por favor, ative o Bluetooth.'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await FlutterBluePlus.turnOn();
                      } catch (e) {
                        scaffoldMessenger.showSnackBar(
                          const SnackBar(content: Text('Não foi possível ativar o Bluetooth')),
                        );
                      }
                    },
                    child: const Text('Ativar Bluetooth'),
                  ),
                ],
              ),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Beacons Ativos',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: BeaconListWidget(beacons: beaconProvider.beaconsInMemory),
                ),
              ],
            )
          );
    });
}
}