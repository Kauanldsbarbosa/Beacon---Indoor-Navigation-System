import 'package:beacon/controllers/navigator_provider.dart';
import 'package:beacon/repositories/navigation_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockNavigationRepository extends Mock implements NavigationRepository {}

void main() {
  late MockNavigationRepository mockNavigationRepository;
  late NavigatorProvider navigatorProvider;
  late int notifyCount;

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall methodCall) async {
        return null;
      },
    );

    mockNavigationRepository = MockNavigationRepository();
    navigatorProvider = NavigatorProvider(
      navigationRepository: mockNavigationRepository,
    );
    notifyCount = 0;
    navigatorProvider.addListener(() {
      notifyCount++;
    });
  });

  tearDown(() {
    navigatorProvider.removeListener(() {});
    navigatorProvider.dispose();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      null,
    );
  });

  group('NavigatorProvider - initializeNavigation', () {
    test('Should initialize navigation successfully', () async {
      await navigatorProvider.initializeNavigation();

      expect(navigatorProvider.initialized, isFalse);
    });
  });

  group('NavigatorProvider - setRouteInstructions', () {
    test('Should set route instructions and notify listeners', () {
      final instructions = [
        'Siga em frente para entrar em Sala 2.',
        'Vire à esquerda para entrar em Sala 3.',
      ];
      final roomsCache = [1, 2, 3];

      when(() => mockNavigationRepository.calculateRoute(1, 3))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache)
          .thenReturn(roomsCache);

      navigatorProvider.setRouteInstructions(1, 3);

      verify(() => mockNavigationRepository.calculateRoute(1, 3)).called(1);
      expect(navigatorProvider.initialized, isTrue);
      expect(navigatorProvider.instructions, equals(instructions));
      expect(navigatorProvider.currentStepIndex, equals(0));
      expect(notifyCount, equals(1));
    });

    test('Should handle empty route instructions', () {
      when(() => mockNavigationRepository.calculateRoute(1, 1))
          .thenReturn([]);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1]);

      navigatorProvider.setRouteInstructions(1, 1);

      expect(navigatorProvider.instructions, isEmpty);
      expect(navigatorProvider.initialized, isTrue);
      expect(notifyCount, equals(1));
    });
  });

  group('NavigatorProvider - nextInstruction', () {
    test('Should move to next instruction and notify listeners', () {
      final instructions = [
        'Instrução 1',
        'Instrução 2',
      ];
      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);
      notifyCount = 0;

      navigatorProvider.nextInstruction(() {});

      expect(navigatorProvider.currentStepIndex, equals(1));
      expect(notifyCount, equals(1));
    });

    test('Should trigger onArrived callback when reaching last instruction', () async {
      bool arrivedCalled = false;
      final instructions = ['Instrução 1'];

      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);
      notifyCount = 0;

      navigatorProvider.nextInstruction(() {
        arrivedCalled = true;
      });

      await Future.delayed(const Duration(seconds: 3));

      expect(arrivedCalled, isTrue);
      expect(notifyCount, equals(1));
    });

    test('Should not move beyond last instruction when already finishing', () {
      final instructions = ['Instrução 1'];

      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);
      navigatorProvider.nextInstruction(() {});
      notifyCount = 0;

      navigatorProvider.nextInstruction(() {});

      expect(notifyCount, equals(0));
    });
  });

  group('NavigatorProvider - resetNavigation', () {
    test('Should reset all navigation state', () {
      final instructions = ['Instrução 1', 'Instrução 2'];

      when(() => mockNavigationRepository.calculateRoute(1, 3))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2, 3]);

      navigatorProvider.setRouteInstructions(1, 3);
      navigatorProvider.nextInstruction(() {});

      navigatorProvider.resetNavigation();

      expect(navigatorProvider.instructions, isEmpty);
      expect(navigatorProvider.currentStepIndex, equals(0));
    });
  });

  group('NavigatorProvider - disposeNavigation', () {
    test('Should dispose navigation and reset all state', () {
      final instructions = ['Instrução 1'];

      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);

      navigatorProvider.disposeNavigation();

      expect(navigatorProvider.initialized, isFalse);
      expect(navigatorProvider.instructions, isEmpty);
      expect(navigatorProvider.currentStepIndex, equals(0));
    });
  });

  group('NavigatorProvider - checkProgress', () {
    test('Should move to next instruction when reaching target room', () {
      final instructions = ['Instrução 1', 'Instrução 2'];

      when(() => mockNavigationRepository.calculateRoute(1, 3))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2, 3]);

      navigatorProvider.setRouteInstructions(1, 3);
      notifyCount = 0;

      navigatorProvider.checkProgress(2, () {});

      expect(navigatorProvider.currentStepIndex, equals(1));
      expect(notifyCount, equals(1));
    });

    test('Should not progress when current room does not match target', () {
      final instructions = ['Instrução 1', 'Instrução 2'];

      when(() => mockNavigationRepository.calculateRoute(1, 3))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2, 3]);

      navigatorProvider.setRouteInstructions(1, 3);
      notifyCount = 0;

      navigatorProvider.checkProgress(5, () {});

      expect(navigatorProvider.currentStepIndex, equals(0));
      expect(notifyCount, equals(0));
    });

    test('Should not progress when navigation is not initialized', () {
      navigatorProvider.checkProgress(2, () {});

      expect(navigatorProvider.currentStepIndex, equals(0));
      expect(notifyCount, equals(0));
    });

    test('Should not progress when current room is null', () {
      final instructions = ['Instrução 1'];

      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);
      notifyCount = 0;

      navigatorProvider.checkProgress(null, () {});

      expect(notifyCount, equals(0));
    });

    test('Should not progress when step index exceeds target rooms cache', () {
      final instructions = ['Instrução 1'];

      when(() => mockNavigationRepository.calculateRoute(1, 2))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2]);

      navigatorProvider.setRouteInstructions(1, 2);
      navigatorProvider.nextInstruction(() {});
      notifyCount = 0;

      navigatorProvider.checkProgress(2, () {});

      expect(notifyCount, equals(0));
    });
  });

  group('NavigatorProvider - speakCurrentInstruction', () {
    test('Should not speak when instructions are empty', () {
      navigatorProvider.speakCurrentInstruction();

      expect(navigatorProvider.instructions, isEmpty);
    });

    test('Should speak current instruction when within bounds', () {
      final instructions = ['Instrução 1', 'Instrução 2'];

      when(() => mockNavigationRepository.calculateRoute(1, 3))
          .thenReturn(instructions);
      when(() => mockNavigationRepository.roomsIdCache).thenReturn([1, 2, 3]);

      navigatorProvider.setRouteInstructions(1, 3);

      navigatorProvider.speakCurrentInstruction();

      expect(navigatorProvider.currentStepIndex, lessThan(instructions.length));
    });
  });
}
