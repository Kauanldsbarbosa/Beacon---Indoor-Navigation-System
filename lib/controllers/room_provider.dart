import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/repositories/room_repository.dart';
import 'package:flutter/material.dart';

class RoomProvider extends ChangeNotifier {
  final RoomRepository roomRepository;

  RoomProvider({required this.roomRepository});

  Room? _currentRoom;
  Room? get currentRoom => _currentRoom;
  set currentRoom(Room? room) {
    _currentRoom = room;
    notifyListeners();
  }

  Future<void> saveRoom(String name, Beacon beacon) async {
    await roomRepository.saveRoom(name, beacon);
    notifyListeners();
  }

  Future<List<Room>> getAllRooms() async {
    return await roomRepository.getAllRooms();
  }

  Future<void> addNeighborToCurrentRoom(
    int neighborId,
    String direction,
  ) async {
    if (_currentRoom == null) return;

    final neighborRoom = await roomRepository.getRoomById(neighborId);
    if (neighborRoom == null) return;

    final newNeighbor = RoomNeighbor()
      ..roomId = neighborId
      ..direction = direction;

    final List<RoomNeighbor> updatedNeighbors =[
      ...?_currentRoom!.neighbors,
      newNeighbor,
    ];

    _currentRoom!.neighbors = updatedNeighbors;



    await roomRepository.addNeighborToRoom(
      _currentRoom!,
      neighborId,
      direction,
    );
    notifyListeners();
  }

  Future<Room?> getRoomById(int id) async {
    return await roomRepository.getRoomById(id);
  }

  Future<List<Room>> getNeighborsRoom(List<int> neighborIds) async {
    return await roomRepository.getNeighborsRoom(neighborIds);
  }
}
