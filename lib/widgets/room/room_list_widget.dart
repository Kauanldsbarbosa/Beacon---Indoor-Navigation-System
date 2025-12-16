import 'package:beacon/models/room/room.dart';
import 'package:beacon/routes/routes.dart';
import 'package:flutter/material.dart';

class RoomListWidget extends StatefulWidget {
  final List<Room> rooms;
  final Function(Room room) onInspect;
  const RoomListWidget({
    super.key,
    required this.rooms,
    required this.onInspect,
  });

  @override
  State<RoomListWidget> createState() => _RoomListWidgetState();
}

class _RoomListWidgetState extends State<RoomListWidget> {

  @override
Widget build(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
    child: ListView.builder(
      itemCount: widget.rooms.length,
      itemBuilder: (context, index) {
        final room = widget.rooms[index];
        return Card(
          color: Theme.of(context).colorScheme.secondaryContainer,
          child: ExpansionTile(
            iconColor: Theme.of(context).colorScheme.onSecondaryContainer,
            title: Text(
              room.name,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            children: [
              Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Column(
                  children: [
                    ListTile(
                title: const Text('Inspecionar Cômodo'),
                onTap: () {
                  widget.onInspect(room);
                },
              ),
              Divider(
                
                color: Theme.of(context).colorScheme.onPrimary,
              ),
              ListTile(
                title: const Text('Ir para Cômodo'),
                onTap: () async {
                  Navigator.pushNamed(context, Routes.navigationPage.path,
                      arguments: {'roomId': room.id});
                },
              )
                  ],
              )
              
          )],
          ),
        );
      },
    ),
  );
}
}