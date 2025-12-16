import 'package:beacon/models/beacon/beacon.dart';
import 'package:beacon/utils/date_utils.dart';
import 'package:flutter/material.dart';

class BeaconCardWidget extends StatefulWidget {
  final Beacon beacon;
  const BeaconCardWidget({super.key, required this.beacon});

  @override
  State<BeaconCardWidget> createState() => _BeaconCardWidgetState();
}

class _BeaconCardWidgetState extends State<BeaconCardWidget> {
  String _lastSeen() {
    if (widget.beacon.lastSeen == null) {
      return "Desconhecido";
    }
    final duration = timeSince(widget.beacon.lastSeen!);
    if (duration < Duration(seconds: 5)) {
      return "Ativo";
    }
    return 'Visto há ${formatDuration(duration)} atrás';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Card(
      color: colorScheme.onPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 40,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                const SizedBox(width: 8),
                Icon(Icons.bluetooth, color: colorScheme.onPrimary),
                const SizedBox(width: 8),
                Text(
                  widget.beacon.name ?? "Beacon Sem Nome",
                  style: TextStyle(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Major: ${widget.beacon.major}',
                  style: TextStyle(fontSize: 16, color: colorScheme.surface),
                ),
                Text(
                  'Minor: ${widget.beacon.minor}',
                  style: TextStyle(fontSize: 16, color: colorScheme.surface),
                ),
                Text(
                  'UUID: ${widget.beacon.uuid}',
                  style: TextStyle(fontSize: 14, color: colorScheme.surface),
                ),
                SizedBox(height: 8),
                Text("media movel rssi: ${widget.beacon.averageRssi.toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 14, color: colorScheme.surface)),
                Row(
                  children: [
                    CircleAvatar(radius: 6, backgroundColor: _lastSeen() == "Ativo"
                        ? Colors.green
                        : Colors.red),
                    SizedBox(width: 8),
                    Text(
                      _lastSeen(),
                      style: TextStyle(
                        fontSize: 14,
                        color: colorScheme.surface,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
