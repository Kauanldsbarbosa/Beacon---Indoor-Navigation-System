import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/controllers/room_provider.dart';
import 'package:beacon/repositories/beacon_repository.dart';
import 'package:beacon/widgets/room/room_form_widget.dart';
import 'package:beacon/widgets/room/room_list_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoomPage extends StatefulWidget {
  const RoomPage({super.key});

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  late Future<(List<Beacon>, List<Room>)> _loadingFuture;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadData();
  }

  Future<(List<Beacon>, List<Room>)> _loadData() async {
    final beaconProvider = context.read<BeaconProvider>();
    final roomProvider = context.read<RoomProvider>();
    final beaconRepo = BeaconRepository(isar: beaconProvider.beaconRepository.isar);

    final results = await Future.wait([
      beaconRepo.getAllBeacons(),
      roomProvider.getAllRooms(),
    ]);

    return (results[0] as List<Beacon>, results[1] as List<Room>);
  }

  void _openRoomForm(BuildContext context, List<Beacon> beacons) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 15,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            child: Container(
              margin: const EdgeInsets.only(bottom: 50),
              child: RoomFormWidget(
                formKey: _formKey,
                beacons: beacons,
                onSubmit: (String nome, Beacon beacon) async {
                  final roomProvider = context.read<RoomProvider>();
                  await roomProvider.saveRoom(nome, beacon);
                  setState(() {
                    _loadingFuture = _loadData();
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final roomProvider = context.read<RoomProvider>();
    return Scaffold(
      body: FutureBuilder<(List<Beacon>, List<Room>)>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final (beacons, rooms) = snapshot.data!;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Cômodos (${rooms.length})',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 16.0),
                Expanded(
                  child: RoomListWidget(rooms: rooms, onInspect: (Room room) { 
                    roomProvider.currentRoom = room;
                    Navigator.pushNamed(context, '/room/inspect');
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      margin: EdgeInsets.only(bottom: 50, right: 30),
                      child: IconButton(
                        onPressed: () => _openRoomForm(context, beacons),
                        icon: Icon(Icons.add),
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          backgroundColor: Theme.of(
                            context,
                          ).colorScheme.primary,
                          foregroundColor: Theme.of(
                            context,
                          ).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: Text('Nenhum cômodo encontrado.'));
          }
        },
      ),
    );
  }
}
