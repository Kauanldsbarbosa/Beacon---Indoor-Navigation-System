import 'package:beacon/widgets/room/room_neighbor_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:beacon/models/room/room.dart';
import 'package:beacon/controllers/beacon_provider.dart';
import 'package:beacon/controllers/room_provider.dart';
import 'package:beacon/widgets/room/room_card_widget.dart';

class RoomInspecterPage extends StatefulWidget {
  const RoomInspecterPage({super.key});

  @override
  State<RoomInspecterPage> createState() => _RoomInspecterPageState();
}

class _RoomInspecterPageState extends State<RoomInspecterPage> {
  Future<void> _showAddNeighborDialog() async {
    final provider = Provider.of<RoomProvider>(context, listen: false);
    final List<Room> rooms = await provider.getAllRooms();
    if (mounted) {
      showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 16.0,
              right: 16.0,
              top: 16.0,
            ),
            margin: const EdgeInsets.only(bottom: 50),
            child: RoomNeighborFormWidget(
              rooms: rooms,
              currentRoom: provider.currentRoom!,
              onSave: (Room selectedRoom, String selectedDirection) async {
                await provider.addNeighborToCurrentRoom(
                  selectedRoom.id,
                  selectedDirection,
                );
              },
            ),
          ),
        );
      },
    );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RoomProvider>(context, listen: false);
    final Room room = provider.currentRoom ?? Room();
    final List<RoomNeighbor> neighbors = List.from(room.neighbors ?? []);
    final beacon = room.beacon.value;

    final beaconUuid = beacon?.uuid ?? 'Desconhecido';
    final beaconMajor = beacon?.major ?? 0;
    final beaconMinor = beacon?.minor ?? 0;
    return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        child: Column(
          children: [
            SizedBox(
              height: 300,
              child: Consumer<BeaconProvider>(
                builder: (context, beaconProvider, child) {
                  return RoomCardWidget(
                    room: room,
                    distanceLabel:
                        beaconProvider
                            .getBeaconByKeyFromMemory(
                              beaconUuid,
                              beaconMajor,
                              beaconMinor,
                            )
                            ?.distanceLabel ??
                        'Desconhecido',
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Vizinhos da sala',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
              height: 200,
              child: FutureBuilder(
                future: provider.getNeighborsRoom(
                  neighbors
                      .where((neighbor) => neighbor.roomId != null)
                      .map((neighbor) => neighbor.roomId!)
                      .toList(),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('Nenhum vizinho encontrado.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: neighbors.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: CircleAvatar(child: Text('${index + 1}')),
                        title: Text(snapshot.data![index].name),
                        subtitle: Text(
                          'Direção: ${neighbors[index].direction}',
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () async {
                  await _showAddNeighborDialog();
                },
                style: TextButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Adicionar vizinho'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
