import 'package:beacon/models/room/room.dart';
import 'package:flutter/material.dart';

class RoomCardWidget extends StatelessWidget {
  final Room room;
  final String distanceLabel;
  const RoomCardWidget({super.key, required this.room, required this.distanceLabel});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primary,
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(room.name, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),),
            const SizedBox(height: 20),
              Text("Você está $distanceLabel", style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Colors.white),),
          ],
        ),
      )
    );
  }
}
