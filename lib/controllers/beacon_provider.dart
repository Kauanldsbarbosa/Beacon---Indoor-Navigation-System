import 'dart:async';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/repositories/beacon_repository.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:beacon/models/beacon/beacon.dart';

class BeaconProvider extends ChangeNotifier {
  final BeaconRepository beaconRepository;

  BeaconProvider({required this.beaconRepository});

  Beacon? _nearestBeacon;
  Beacon? _candidateBeacon;

  Timer? _candidateTimer;

  List<Beacon> get beaconsInMemory => beaconRepository.beaconsInMemory;

  Beacon? get getNearestBeacon => _nearestBeacon;
  Room? get currentRoom => _nearestBeacon?.room.value;

  Future<void> startBeacon() async {
    beaconRepository.startBeaconScanning(() {
      notifyListeners();
      _evaluateNearestBeacon();
    });
  }

  bool isBeacon(List<int> bytes) {
    if (bytes.length < 23) return false;
    String uuid = bytes
        .sublist(2, 18)
        .map((b) => b.toRadixString(16).padLeft(2, '0'))
        .join();
    return uuid.toLowerCase() == 'fda50693a4e24fb1afcfc6eb07647825';
  }

  @override
  void dispose() {
    beaconRepository.stopBeacon();
    super.dispose();
  }

  Beacon? getBeaconByKeyFromMemory(String uuid, int major, int minor) {
    try {
      return beaconRepository.beaconsInMemory.firstWhere(
        (beacon) =>
            beacon.uuid.toLowerCase() == uuid.toLowerCase() &&
            beacon.major == major &&
            beacon.minor == minor,
      );
    } catch (e) {
      return null;
    }
  }

  Future updateNearestBeacon(Beacon beacon) async {
    beaconRepository.beaconsInMemory[beacon.id] = beacon;
    _evaluateNearestBeacon();
  }

  Future<void> _evaluateNearestBeacon() async {
    final beaconsInMemory = beaconRepository.beaconsInMemory;
    if (beaconsInMemory.isEmpty) return;
    final strongestBeacon = beaconsInMemory.reduce(
      (a, b) => a.averageRssi > b.averageRssi ? a : b,
    );
    if (_candidateBeacon == null) {
      _candidateBeacon = strongestBeacon;
      notifyListeners();
      return;
    }

    if (_nearestBeacon == null) {
      _nearestBeacon = strongestBeacon;
      if (_nearestBeacon!.room.value != null) {
        _nearestBeacon!.room.loadSync();
      }
      notifyListeners();
      return;
    }

    if (_nearestBeacon?.id == strongestBeacon.id) {
      _candidateTimer?.cancel();
      return;
    }
    if (_candidateBeacon?.id != strongestBeacon.id) {
      _candidateBeacon = strongestBeacon;
      _candidateTimer?.cancel();
      _candidateTimer = Timer(const Duration(seconds: 2), () async {
        await _updateNearestBEaconFromCollection(_candidateBeacon!);
        _candidateBeacon = null;
      });
    }
  }

  Future<void> _updateNearestBEaconFromCollection(Beacon beacon) async {
    final dbBeacon = await beaconRepository.isar.beacons
        .filter()
        .uuidEqualTo(beacon.uuid)
        .majorEqualTo(beacon.major)
        .minorEqualTo(beacon.minor)
        .findFirst();

    if (dbBeacon != null) {
      _nearestBeacon = dbBeacon;
      notifyListeners();
    }
    await _nearestBeacon!.room.load();
    notifyListeners();
  }
}
