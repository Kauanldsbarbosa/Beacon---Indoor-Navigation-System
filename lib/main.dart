import 'package:beacon/controllers/navigator_provider.dart';
import 'package:beacon/core/layouts/main_layout.dart';
import 'package:beacon/core/themes.dart';
import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/pages/beacon/beacon_page.dart';
import 'package:beacon/pages/beacon/previous_beacons_page.dart';
import 'package:beacon/pages/navigation/navigation_page.dart';
import 'package:beacon/pages/room/room_inspecter_page.dart';
import 'package:beacon/pages/room/room_page.dart';
import 'package:beacon/controllers/room_provider.dart';
import 'package:beacon/repositories/beacon_repository.dart';
import 'package:beacon/repositories/navigation_repository.dart';
import 'package:beacon/repositories/room_repository.dart';
import 'package:beacon/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:beacon/controllers/beacon_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dir = await getApplicationDocumentsDirectory();

  final isar = await Isar.open([BeaconSchema, RoomSchema], directory: dir.path);
  final roomRepository = RoomRepository(isar);
  final beaconRepository = BeaconRepository(isar: isar);
  final navigationRepository = NavigationRepository(isar: isar);
  await navigationRepository.init();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          lazy: false,
          create: (_) =>
              BeaconProvider(beaconRepository: beaconRepository)..startBeacon(),
        ),
        ChangeNotifierProvider(
          create: (_) => RoomProvider(roomRepository: roomRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              NavigatorProvider(navigationRepository: navigationRepository)
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beacons - See U',
      theme: SeeUTheme.lightTheme,
      darkTheme: SeeUTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.activeBeacons.path,
      routes: {
        Routes.activeBeacons.path: (context) =>
            const MainLayout(child: BeaconPage()),
        Routes.previousBeacons.path: (context) =>
            const MainLayout(child: PreviousBeaconsPage()),
        Routes.roomPage.path: (context) => MainLayout(child: RoomPage()),
        Routes.roomInspectPage.path: (context) =>
            MainLayout(child: RoomInspecterPage()),
        Routes.navigationPage.path: (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final toRoomId = args['roomId'] as int;
          return MainLayout(
            child: NavigationPage(
              toRoomId: toRoomId,
              roomRepository: context.read<RoomProvider>().roomRepository,
            ),
          );
        },
      },
    );
  }
}
