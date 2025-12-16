import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:isar/isar.dart';

class RoomRepository {
  final Isar isar;
  RoomRepository(this.isar);

  Future<void> saveRoom(String name, Beacon beacon) async {
    final room = Room()..name = name;
    await isar.writeTxn(() async {
      await isar.rooms.put(room);
      room.beacon.value = beacon;
      await room.beacon.save();
    });
  }

  Future<List<Room>> getAllRooms() async {
    return await isar.rooms.where().findAll();
  }


  Future<Room?> getRoomById(int id) async {
    return await isar.rooms.filter().idEqualTo(id).findFirst();
  }

  Future<List<Room>> getNeighborsRoom(List<int> neighborIds) async {
    return await isar.rooms
        .where()
        .anyOf(neighborIds, (q, int id) => q.idEqualTo(id))
        .findAll();
  }

  Future<void> addNeighborToRoom(
    Room room,
    int neighborId,
    String direction,
  ) async {
    final neighborRoom = await isar.rooms
        .filter()
        .idEqualTo(neighborId)
        .findFirst();
    if (neighborRoom == null) return;

    final newNeighbor = RoomNeighbor()
      ..roomId = neighborId
      ..direction = direction;

    final List<RoomNeighbor> updatedNeighbors = [
      ...?room.neighbors,
      newNeighbor,
    ];

    room.neighbors = updatedNeighbors;

    await isar.writeTxn(() async {
      await isar.rooms.put(room);
    });
  }
}