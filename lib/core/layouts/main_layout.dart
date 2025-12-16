import 'dart:async';

import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/widgets/navigation_drawer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  final Widget child; 
  const MainLayout({super.key, required this.child});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  late final StreamSubscription<BluetoothAdapterState> _btSubscription;

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
    final colorScheme = Theme.of(context).colorScheme;
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Beacon App', style: TextStyle(color: colorScheme.onPrimary),),
        backgroundColor: colorScheme.primary,
        iconTheme: IconThemeData(color: colorScheme.onPrimary),
      ),
      body: StreamBuilder<BluetoothAdapterState>(
        stream: FlutterBluePlus.adapterState,
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
          return widget.child;
        }
      ),
      drawer: const NavigationDrawerWidget(),
    );
  }
}
