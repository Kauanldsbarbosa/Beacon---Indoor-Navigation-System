import 'dart:collection';

import 'package:beacon/models/room/room.dart';
import 'package:isar/isar.dart';

class NavigationRepository {
  final Isar isar;
  NavigationRepository({required this.isar});

  final Map<Id, String> _roomNamesCache = {};
  final List<int> _roomsIdCache = [];
  final Map<Id, List<RoomNeighbor>> _graph = {};

  Future<void> init() async {
    final rooms = await isar.rooms.where().findAll();
    _graph.clear();
    _roomNamesCache.clear();
    for (var room in rooms) {
      _roomNamesCache[room.id] = room.name;
      _graph[room.id] = room.neighbors ?? [];
    }
  }

  List<String> calculateRoute(Id fromRoomId, Id toRoomId) {
    if (fromRoomId == toRoomId) return ['Você já está na sala de destino.'];
    Queue<List<Id>> queue = Queue();
    queue.add([fromRoomId]);
    Set<Id> visited = {fromRoomId};
    while (queue.isNotEmpty) {
      List<Id> path = queue.removeFirst();
      Id lastRoomId = path.last;

      if (lastRoomId == toRoomId) {
        _roomsIdCache.addAll(path);
        return _buildInstructionsFromPath(path);
      }

      final neighbors = _graph[lastRoomId] ?? [];
      for (var neighbor in neighbors) {
        if (neighbor.roomId != null && !visited.contains(neighbor.roomId)) {
          visited.add(neighbor.roomId!);
          List<Id> newPath = List.from(path)..add(neighbor.roomId!);
          queue.add(newPath);
        }
      }
    }
    return ['Rota não encontrada.'];
  }

  List<String> _buildInstructionsFromPath(List<Id> path) {
    List<String> instructions = [];
    for (int i = 0; i < path.length - 1; i++) {
      Id currentRoomId = path[i];
      Id nextRoomId = path[i + 1];
      List<RoomNeighbor> neighbors = _graph[currentRoomId] ?? [];
      RoomNeighbor? step = neighbors.firstWhere(
          (neighbor) => neighbor.roomId == nextRoomId,
          orElse: () => RoomNeighbor()..direction = 'frente');

        String nextName = _roomNamesCache[nextRoomId] ?? 'Próxima sala';
        String tepDirection = step.direction ?? 'frente';
        instructions.add(_formatText(tepDirection, nextName));
    }
    return instructions;
  }

  String _formatText(String direction, String roomName) {
    switch (direction.toLowerCase()) {
      case 'esquerda':
        return 'Vire à esquerda para entrar em $roomName.';
      case 'direita':
        return 'Vire à direita para entrar em $roomName.';
      case 'atrás':
        return 'Vire atrás para entrar em $roomName.';
      case 'frente':
      default:
        return 'Siga em frente para entrar em $roomName.';
    }
  }

  List<int> get roomsIdCache => _roomsIdCache;

  

}
