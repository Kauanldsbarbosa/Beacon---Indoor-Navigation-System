import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/controllers/room_provider.dart';
import 'package:beacon/repositories/room_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockRoomRepository extends Mock implements RoomRepository {}

void main() {
  late MockRoomRepository mockRoomRepository;
  late RoomProvider roomProvider;
  late int notifyCount;

  setUpAll(() {
    registerFallbackValue(Room());
    registerFallbackValue(Beacon(
      uuid: 'test-uuid',
      major: 0,
      minor: 0,
      txPower: 0,
    ));
  });

  setUp(() {
    mockRoomRepository = MockRoomRepository();
    roomProvider = RoomProvider(roomRepository: mockRoomRepository);
    notifyCount = 0;
    roomProvider.addListener(() {
      notifyCount++;
    });
  });

  tearDown(() {
    roomProvider.removeListener(() {});
    roomProvider.dispose();
  });

  group('RoomProvider - currentRoom', () {
    test('Should set currentRoom and notify listeners', () {
      final room = Room()
        ..id = 1
        ..name = 'Living Room';

      roomProvider.currentRoom = room;

      expect(roomProvider.currentRoom, equals(room));
      expect(roomProvider.currentRoom?.name, equals('Living Room'));
      expect(notifyCount, equals(1));
    });

    test('Should set currentRoom to null and notify listeners', () {
      final room = Room()
        ..id = 1
        ..name = 'Bedroom';
      roomProvider.currentRoom = room;
      final previousNotifyCount = notifyCount;

      roomProvider.currentRoom = null;

      expect(roomProvider.currentRoom, isNull);
      expect(notifyCount, equals(previousNotifyCount + 1));
    });
  });

  group('RoomProvider - saveRoom', () {
    test('Should save room successfully and notify listeners', () async {
      const roomName = 'Kitchen';
      final beacon = Beacon(
        uuid: 'fda50693a4e24fb1afcfc6eb07647825',
        major: 1,
        minor: 1,
        txPower: -59,
        name: 'Beacon 1',
      );
      when(() => mockRoomRepository.saveRoom(roomName, beacon))
          .thenAnswer((_) async {});

      await roomProvider.saveRoom(roomName, beacon);

      verify(() => mockRoomRepository.saveRoom(roomName, beacon)).called(1);
      expect(notifyCount, equals(1));
    });

    test('Should throw exception when repository fails to save room', () async {
      const roomName = 'Bathroom';
      final beacon = Beacon(
        uuid: 'fda50693a4e24fb1afcfc6eb07647825',
        major: 2,
        minor: 2,
        txPower: -59,
      );
      when(() => mockRoomRepository.saveRoom(roomName, beacon))
          .thenThrow(Exception('Database error'));

      expect(
        () => roomProvider.saveRoom(roomName, beacon),
        throwsException,
      );
    });
  });

  group('RoomProvider - getAllRooms', () {
    test('Should return all rooms successfully', () async {
      final room1 = Room()
        ..id = 1
        ..name = 'Room 1';
      final room2 = Room()
        ..id = 2
        ..name = 'Room 2';
      final roomsList = [room1, room2];
      when(() => mockRoomRepository.getAllRooms())
          .thenAnswer((_) async => roomsList);

      final result = await roomProvider.getAllRooms();

      verify(() => mockRoomRepository.getAllRooms()).called(1);
      expect(result, equals(roomsList));
      expect(result.length, equals(2));
    });

    test('Should return empty list when no rooms exist', () async {
      when(() => mockRoomRepository.getAllRooms())
          .thenAnswer((_) async => []);

      final result = await roomProvider.getAllRooms();

      verify(() => mockRoomRepository.getAllRooms()).called(1);
      expect(result, isEmpty);
    });

    test('Should throw exception when repository fails to fetch rooms', () async {
      when(() => mockRoomRepository.getAllRooms())
          .thenThrow(Exception('Database connection error'));

      expect(
        () => roomProvider.getAllRooms(),
        throwsException,
      );
    });
  });

  group('RoomProvider - getRoomById', () {
    test('Should return room by id successfully', () async {
      final room = Room()
        ..id = 1
        ..name = 'Dining Room';
      when(() => mockRoomRepository.getRoomById(1))
          .thenAnswer((_) async => room);

      final result = await roomProvider.getRoomById(1);

      verify(() => mockRoomRepository.getRoomById(1)).called(1);
      expect(result, equals(room));
      expect(result?.name, equals('Dining Room'));
    });

    test('Should return null when room does not exist', () async {
      when(() => mockRoomRepository.getRoomById(999))
          .thenAnswer((_) async => null);

      final result = await roomProvider.getRoomById(999);

      verify(() => mockRoomRepository.getRoomById(999)).called(1);
      expect(result, isNull);
    });

    test('Should throw exception when repository fails', () async {
      when(() => mockRoomRepository.getRoomById(1))
          .thenThrow(Exception('Database error'));

      expect(
        () => roomProvider.getRoomById(1),
        throwsException,
      );
    });
  });

  group('RoomProvider - getNeighborsRoom', () {
    test('Should return neighbor rooms successfully', () async {
      final neighborRoom1 = Room()
        ..id = 2
        ..name = 'Neighbor 1';
      final neighborRoom2 = Room()
        ..id = 3
        ..name = 'Neighbor 2';
      final neighborsList = [neighborRoom1, neighborRoom2];
      when(() => mockRoomRepository.getNeighborsRoom([2, 3]))
          .thenAnswer((_) async => neighborsList);

      final result = await roomProvider.getNeighborsRoom([2, 3]);

      verify(() => mockRoomRepository.getNeighborsRoom([2, 3])).called(1);
      expect(result, equals(neighborsList));
      expect(result.length, equals(2));
    });

    test('Should return empty list when no neighbors are found', () async {
      when(() => mockRoomRepository.getNeighborsRoom([]))
          .thenAnswer((_) async => []);

      final result = await roomProvider.getNeighborsRoom([]);

      verify(() => mockRoomRepository.getNeighborsRoom([])).called(1);
      expect(result, isEmpty);
    });

    test('Should throw exception when repository fails to fetch neighbors', () async {
      when(() => mockRoomRepository.getNeighborsRoom([1, 2]))
          .thenThrow(Exception('Database error'));

      expect(
        () => roomProvider.getNeighborsRoom([1, 2]),
        throwsException,
      );
    });
  });

  group('RoomProvider - addNeighborToCurrentRoom', () {
    test('Should add neighbor to current room and notify listeners', () async {
      final currentRoom = Room()
        ..id = 1
        ..name = 'Main Room';
      roomProvider.currentRoom = currentRoom;
      notifyCount = 0;

      final neighborRoom = Room()
        ..id = 2
        ..name = 'Neighbor Room';
      when(() => mockRoomRepository.getRoomById(2))
          .thenAnswer((_) async => neighborRoom);
      when(() => mockRoomRepository.addNeighborToRoom(
            any(that: isA<Room>()),
            2,
            'frente',
          )).thenAnswer((_) async {});

      await roomProvider.addNeighborToCurrentRoom(2, 'frente');

      verify(() => mockRoomRepository.getRoomById(2)).called(1);
      verify(() => mockRoomRepository.addNeighborToRoom(
            any(that: isA<Room>()),
            2,
            'frente',
          )).called(1);
      expect(roomProvider.currentRoom?.neighbors, isNotNull);
      expect(roomProvider.currentRoom?.neighbors?.length, equals(1));
      expect(roomProvider.currentRoom?.neighbors?[0].direction, equals('frente'));
      expect(notifyCount, equals(1));
    });

    test('Should not add neighbor when current room is null', () async {
      roomProvider.currentRoom = null;
      notifyCount = 0;

      await roomProvider.addNeighborToCurrentRoom(2, 'esquerda');

      verifyNever(() => mockRoomRepository.getRoomById(any(that: isA<int>())));
      expect(notifyCount, equals(0));
    });

    test('Should not add neighbor when neighbor room does not exist', () async {
      final currentRoom = Room()
        ..id = 1
        ..name = 'Main Room';
      roomProvider.currentRoom = currentRoom;
      notifyCount = 0;

      when(() => mockRoomRepository.getRoomById(999))
          .thenAnswer((_) async => null);

      await roomProvider.addNeighborToCurrentRoom(999, 'direita');

      verify(() => mockRoomRepository.getRoomById(999)).called(1);
      verifyNever(() => mockRoomRepository.addNeighborToRoom(
            any(that: isA<Room>()),
            any(that: isA<int>()),
            any(that: isA<String>()),
          ));
      expect(notifyCount, equals(0));
    });

    test('Should add multiple neighbors to current room', () async {
      final currentRoom = Room()
        ..id = 1
        ..name = 'Main Room';
      roomProvider.currentRoom = currentRoom;
      notifyCount = 0;

      final neighborRoom1 = Room()
        ..id = 2
        ..name = 'Neighbor 1';
      final neighborRoom2 = Room()
        ..id = 3
        ..name = 'Neighbor 2';

      when(() => mockRoomRepository.getRoomById(2))
          .thenAnswer((_) async => neighborRoom1);
      when(() => mockRoomRepository.getRoomById(3))
          .thenAnswer((_) async => neighborRoom2);
      when(() => mockRoomRepository.addNeighborToRoom(
            any(that: isA<Room>()),
            any(that: isA<int>()),
            any(that: isA<String>()),
          )).thenAnswer((_) async {});

      await roomProvider.addNeighborToCurrentRoom(2, 'frente');
      await roomProvider.addNeighborToCurrentRoom(3, 'atrás');

      expect(roomProvider.currentRoom?.neighbors?.length, equals(2));
      expect(roomProvider.currentRoom?.neighbors?[0].roomId, equals(2));
      expect(roomProvider.currentRoom?.neighbors?[1].roomId, equals(3));
      expect(notifyCount, equals(2));
    });

    test('Should throw exception when repository fails to add neighbor', () async {
      final currentRoom = Room()
        ..id = 1
        ..name = 'Main Room';
      roomProvider.currentRoom = currentRoom;

      final neighborRoom = Room()
        ..id = 2
        ..name = 'Neighbor Room';
      when(() => mockRoomRepository.getRoomById(2))
          .thenAnswer((_) async => neighborRoom);
      when(() => mockRoomRepository.addNeighborToRoom(
            any(that: isA<Room>()),
            2,
            'esquerda',
          )).thenThrow(Exception('Database error'));

      expect(
        () => roomProvider.addNeighborToCurrentRoom(2, 'esquerda'),
        throwsException,
      );
    });
  });
}
