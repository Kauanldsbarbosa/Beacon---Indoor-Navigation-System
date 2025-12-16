import 'package:beacon/models/beacon/beacon.dart';
import 'package:isar/isar.dart';

part 'room.g.dart';

@collection
class Room {
  Id id = Isar.autoIncrement;

  late String name;

  @Backlink(to: 'room')
  final beacon = IsarLink<Beacon>();
 
 List<RoomNeighbor>? neighbors;
}

@embedded
class RoomNeighbor {
  late int? roomId;
  late String? direction;
}
