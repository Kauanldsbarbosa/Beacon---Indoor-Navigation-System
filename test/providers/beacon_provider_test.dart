import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/repositories/beacon_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBeaconRepository extends Mock implements BeaconRepository {}

List<int> _hexToBytes(String hex) {
  final result = <int>[];
  for (var i = 0; i < hex.length; i += 2) {
    result.add(int.parse(hex.substring(i, i + 2), radix: 16));
  }
  return result;
}

void main() {
  late MockBeaconRepository mockBeaconRepository;
  BeaconProvider? beaconProvider;
  late int notifyCount;

  setUp(() {
    mockBeaconRepository = MockBeaconRepository();
    when(() => mockBeaconRepository.stopBeacon()).thenAnswer((_) async {});
    beaconProvider = BeaconProvider(beaconRepository: mockBeaconRepository);
    notifyCount = 0;
    beaconProvider!.addListener(() {
      notifyCount++;
    });
  });

  tearDown(() {
    beaconProvider?.dispose();
  });

  group('BeaconProvider - startBeacon', () {
    test('Should start scanning and notify listeners', () async {
      when(() => mockBeaconRepository.startBeaconScanning(any()))
          .thenAnswer((invocation) async {
        final cb = invocation.positionalArguments[0] as Function;
        cb();
      });
      when(() => mockBeaconRepository.beaconsInMemory).thenReturn([]);

      await beaconProvider!.startBeacon();

      verify(() => mockBeaconRepository.startBeaconScanning(any())).called(1);
      expect(notifyCount, equals(1));
    });
  });

  group('BeaconProvider - dispose', () {
    test('Should stop beacon scanning on dispose', () {
      when(() => mockBeaconRepository.stopBeacon())
          .thenAnswer((_) async {});

      beaconProvider!.dispose();
      beaconProvider = null;

      verify(() => mockBeaconRepository.stopBeacon()).called(1);
    });
  });

  group('BeaconProvider - isBeacon', () {
    test('Should return true for matching UUID bytes', () {
      const uuid = 'fda50693a4e24fb1afcfc6eb07647825';
      final bytes = <int>[
        0x00, 0x00,
        ..._hexToBytes(uuid),
        0x00, 0x01, 0x00, 0x02, 0xC5,
      ];

      final result = beaconProvider!.isBeacon(bytes);

      expect(result, isTrue);
    });

    test('Should return false for non-matching UUID bytes', () {
      const uuid = '00112233445566778899aabbccddeeff';
      final bytes = <int>[
        0x00, 0x00,
        ..._hexToBytes(uuid),
        0x00, 0x01, 0x00, 0x02, 0xC5,
      ];

      final result = beaconProvider!.isBeacon(bytes);

      expect(result, isFalse);
    });

    test('Should return false when bytes length is insufficient', () {
      final bytes = <int>[0x00, 0x01, 0x02];

      final result = beaconProvider!.isBeacon(bytes);

      expect(result, isFalse);
    });
  });

  group('BeaconProvider - getBeaconByKeyFromMemory', () {
    test('Should return beacon when it exists in memory', () {
      final beacon = Beacon(
        uuid: 'fda50693a4e24fb1afcfc6eb07647825',
        major: 1,
        minor: 2,
        txPower: -59,
        name: 'Test Beacon',
      );
      when(() => mockBeaconRepository.beaconsInMemory)
          .thenReturn([beacon]);

      final result = beaconProvider!.getBeaconByKeyFromMemory(
        'fda50693a4e24fb1afcfc6eb07647825',
        1,
        2,
      );

      expect(result, isNotNull);
      expect(result?.name, equals('Test Beacon'));
    });

    test('Should return null when beacon is not found', () {
      when(() => mockBeaconRepository.beaconsInMemory)
          .thenReturn([]);

      final result = beaconProvider!.getBeaconByKeyFromMemory(
        'unknown-uuid',
        10,
        20,
      );

      expect(result, isNull);
    });
  });
}