import 'dart:math';
import 'package:beacon/models/room/room.dart';
import 'package:isar/isar.dart';

part 'beacon.g.dart';

@collection
class Beacon {
  Id get id => fastHash('$uuid-$major-$minor');

  @Index()
  final String uuid;
  final int major;
  final int minor;
  final int txPower;
  
  String? beaconId;
  String? name;
  DateTime? lastSeen;
  
  final room = IsarLink<Room>();
  @ignore
  final List<int> _rssiBuffer = []; 

  @ignore
  String _currentStatus = "Procurando...";

  Beacon({
    required this.uuid,
    required this.major,
    required this.minor,
    required this.txPower,
    this.beaconId,
    this.name,
    this.lastSeen,
  });

  void processarSinal(int rssi) {
    lastSeen = DateTime.now();
    _rssiBuffer.add(rssi);
    if (_rssiBuffer.length > 12) {
      _rssiBuffer.removeAt(0);
    }
    double mediaRssi = _rssiBuffer.reduce((a, b) => a + b) / _rssiBuffer.length;
    int effectiveTxPower = (txPower >= 0) ? -59 : txPower;
    double distanciaMetros = pow(10, ((effectiveTxPower - mediaRssi) / (10 * 2.5))).toDouble();

    if (distanciaMetros < 1.0) {
      _currentStatus = 'Próximo';
    } else if (distanciaMetros < 3.5) {
      _currentStatus = 'Médio';
    } else {
      _currentStatus = 'Distante';
    }
  }

  String get distanceLabel => _currentStatus;
  
  double get averageRssi => _rssiBuffer.isNotEmpty 
      ? _rssiBuffer.reduce((a, b) => a + b) / _rssiBuffer.length 
      : 0.0;

  int fastHash(String string) {
    var hash = 0xcbf29ce484222325;
    var i = 0;
    while (i < string.length) {
      final codeUnit = string.codeUnitAt(i++);
      hash ^= codeUnit >> 8;
      hash *= 0x100000001b3;
      hash ^= codeUnit & 0xFF;
      hash *= 0x100000001b3;
    }
    return hash;
  }
}