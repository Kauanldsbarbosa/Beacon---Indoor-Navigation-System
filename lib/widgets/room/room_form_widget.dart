import 'package:beacon/models/beacon/beacon.dart';
import 'package:flutter/material.dart';

class RoomFormWidget extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(String nome, Beacon beacon) onSubmit;
  final List<Beacon> beacons;

  const RoomFormWidget({
    super.key,
    required this.formKey,
    required this.onSubmit,
    required this.beacons,
  });

  @override
  State<RoomFormWidget> createState() => _RoomFormWidgetState();
}

class _RoomFormWidgetState extends State<RoomFormWidget> {
  final _nameController = TextEditingController();
  Beacon? _selectedBeacon;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.beacons.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(20.0),
        child: Center(child: Text("Nenhum Beacon cadastrado para vincular.")),
      );
    }

    return Form(
      key: widget.formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Nome do Cômodo',
              border: OutlineInputBorder(),
            ),
            validator: (value) =>
                (value == null || value.isEmpty) ? 'Informe o nome' : null,
          ),
          const SizedBox(height: 20),
          const SizedBox(height: 20),
          DropdownButtonFormField<Beacon>(
            isExpanded: true, 
            decoration: const InputDecoration(
              labelText: 'Selecionar Beacon',
              border: OutlineInputBorder(),
            ),
            hint: const Text('Toque para selecionar...'),
            items: widget.beacons.map((beacon) {
              return DropdownMenuItem<Beacon>(
                value: beacon, // O ID único do beacon
                child: Text(
                  beacon.name ?? 'Beacon sem nome',
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBeacon = value;
              });
            },
            validator: (value) => value == null ? 'Selecione um beacon' : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (widget.formKey.currentState!.validate()) {
                  widget.onSubmit(_nameController.text, _selectedBeacon!);
                }
              },
              child: const Text('Salvar'),
            ),
          ),
        ],
      ),
    );
  }
}