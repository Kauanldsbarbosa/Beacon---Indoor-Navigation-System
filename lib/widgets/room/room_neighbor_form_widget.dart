import 'package:beacon/models/room/room.dart';
import 'package:flutter/material.dart';

class RoomNeighborFormWidget extends StatefulWidget {
  final Function(Room, String) onSave;
  final List<Room> rooms;
  final Room currentRoom;
  const RoomNeighborFormWidget({
    super.key,
    required this.onSave,
    required this.rooms,
    required this.currentRoom,
  });

  @override
  State<RoomNeighborFormWidget> createState() => _RoomNeighborFormWidgetState();
}

class _RoomNeighborFormWidgetState extends State<RoomNeighborFormWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Room _selectedRoom = Room();
  String _selectedDirection = '';
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const Text(
            'Adicionar Vizinho',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<Room>(
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Cômodo Vizinho',
              border: OutlineInputBorder(),
            ),
            items: widget.rooms
                .where((room) => room.name != widget.currentRoom.name)
                .map(
                  (room) => DropdownMenuItem<Room>(
                    value: room,
                    child: Text(room.name),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _selectedRoom = value!;
            },
            validator: (value) => (value == null || value.name.isEmpty)
                ? 'Selecione um cômodo'
                : null,
          ),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Direção',
              border: OutlineInputBorder(),
            ),
            items: ['frente', 'atrás', 'esquerda', 'direita']
                .map(
                  (direction) => DropdownMenuItem<String>(
                    value: direction,
                    child: Text(direction),
                  ),
                )
                .toList(),
            onChanged: (value) {
              _selectedDirection = value!;
            },
            validator: (value) => (value == null || value.isEmpty)
                ? 'Selecione uma direção'
                : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  widget.onSave(
                    _selectedRoom,
                    _selectedDirection,
                  );
                }
              },
              child: const Text('Salvar Vizinho'),
            ),
          ),
        ],
      ),
    );
  }
}
