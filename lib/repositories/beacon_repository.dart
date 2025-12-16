import 'dart:async';

import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/services/bluetooth_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:isar/isar.dart';

class BeaconRepository {
  final Isar isar;
  final AppBluetoothService bluetoothService;
  BeaconRepository({
    required this.isar, 
    AppBluetoothService? bluetoothService
  }) : bluetoothService = bluetoothService ?? AppBluetoothService.instance;

  final List<Beacon> _beacons = [];
  final Set<Beacon> _beaconsToSave = {};

  List<Beacon> get beaconsInMemory => _beacons;

  StreamSubscription? _scanSubscription;
  Timer? _saveTimer;
  Future<void> startBeaconScanning(Function onBatchChanged) async {
    if (FlutterBluePlus.isScanningNow) return;

    _startAutoSaveTimer();

    try {
      await bluetoothService.startScan();

      _scanSubscription = bluetoothService.scanResults.listen((results) async {
        bool batchChanged = false;

        for (ScanResult r in results) {
          for (var adData in r.advertisementData.manufacturerData.values) {
            if (_isBeacon(adData)) {
              final tempBeaconInfo = _fromBytes(adData);
              Beacon? targetBeacon = await getBeaconByKey(
                tempBeaconInfo.uuid,
                tempBeaconInfo.major,
                tempBeaconInfo.minor,
              );
              if (targetBeacon == null) {
                targetBeacon = await getBeaconByKey(
                  tempBeaconInfo.uuid,
                  tempBeaconInfo.major,
                  tempBeaconInfo.minor,
                );
                if (targetBeacon != null) {
                  _beacons.add(targetBeacon);
                }
              }
              if (targetBeacon == null) {
                targetBeacon = tempBeaconInfo;
                targetBeacon.name ??= r.device.platformName.isNotEmpty
                    ? r.device.platformName
                    : "Beacon Sem Nome";
              }
              targetBeacon.lastSeen = r.timeStamp;
              targetBeacon.processarSinal(r.rssi);
              _beaconsToSave.add(targetBeacon);
              _updateOrAddBeaconInMemory(targetBeacon);
              batchChanged = true;
            }
            if (batchChanged) {
              onBatchChanged();
            }
          }
        }
      });
    } catch (e) {
      throw Exception('Error starting beacon scan: $e');
    }
  }

  Future<void> stopBeacon() async {
    try {
      await FlutterBluePlus.stopScan();
      await _scanSubscription?.cancel();
      _scanSubscription = null;
    } catch (e) {
      throw Exception('Error stopping beacon scan: $e');
    }
  }

  Future<void> saveBeacon(Beacon beacon) async {
    await isar.writeTxn(() async {
      if (beacon.room.value != null) {
        final room = await isar.rooms.get(beacon.room.value!.id);
        if (room != null) {
          beacon.room.value = room;
        }
      }
      await isar.beacons.put(beacon);
    });
  }

  Future<void> saveAllBeacons(List<Beacon> beacons) async {
    if (beacons.isEmpty) return;
    await isar.writeTxn(() async {
      await isar.beacons.putAll(beacons);
    });
  }

  Future<List<Beacon>> getAllBeacons() async {
    return await isar.beacons.where().findAll();
  }

  Future<Beacon?> getBeaconByKey(String uuid, int major, int minor) async {
    return await isar.beacons
        .where()
        .filter()
        .uuidEqualTo(uuid)
        .majorEqualTo(major)
        .minorEqualTo(minor)
        .findFirst();
  }

  static Beacon _fromBytes(List<int> bytes) {
    final uuid = bytes
        .sublist(2, 18)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    final major = (bytes[18] << 8) + bytes[19];
    final minor = (bytes[20] << 8) + bytes[21];
    final txPower = bytes[22];

    return Beacon(uuid: uuid, major: major, minor: minor, txPower: txPower);
  }

  bool _isBeacon(List<int> bytes) {
    if (bytes.length < 23) return false;
    String uuid = bytes
        .sublist(2, 18)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return uuid.toLowerCase() == 'fda50693a4e24fb1afcfc6eb07647825';
  }

  void _updateOrAddBeaconInMemory(Beacon beacon) {
    final index = _beacons.indexWhere(
      (b) =>
          b.uuid == beacon.uuid &&
          b.major == beacon.major &&
          b.minor == beacon.minor,
    );
    if (index != -1) {
      _beacons[index] = beacon;
    } else {
      _beacons.add(beacon);
    }
  }

  void _startAutoSaveTimer() {
    _stopAutoSaveTimer();
   _saveTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (_beaconsToSave.isEmpty) return;
      final beacons = _beaconsToSave.toList();
      _beaconsToSave.clear();
      await saveAllBeacons(beacons);
    });
  }

  void _stopAutoSaveTimer() {
    _saveTimer?.cancel();
    _saveTimer = null;
  }
}
