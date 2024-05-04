import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import '../provider/plant_provider.dart';
import 'package:provider/provider.dart';

class PlantUpdate extends StatefulWidget {
  final Plant plant;

  const PlantUpdate({Key? key, required this.plant}) : super(key: key);

  @override
  State<PlantUpdate> createState() => _PlantUpdateState();
}

class _PlantUpdateState extends State<PlantUpdate> {
  late TextEditingController _nameController;
  bool _germinatedController = false;
  late TextEditingController _days_to_harvestController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _germinatedController = widget.plant.germinated;
    _days_to_harvestController =
        TextEditingController(text: widget.plant.days_to_harvest.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Plant'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            controller: _nameController,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Days to Harvest',
              border: OutlineInputBorder(),
            ),
            controller: _days_to_harvestController,
          ),
          const SizedBox(height: 20.0),
          ListTile(
            leading: const Text('Plant has germinated'),
            trailing: Switch(
              value: _germinatedController,
              onChanged: (bool value) {
                setState(() {
                  _germinatedController = value;
                });
              },
            ),
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              updatePlantInfo();
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }

  void updatePlantInfo() async {
    try {
      Map<String, dynamic> plantData = {
        'id': widget.plant.id,
        'name': _nameController.text.trim(),
        'germinated': _germinatedController,
        'garden_id': widget.plant.garden_id,
        'days_to_harvest': int.parse(_days_to_harvestController.text.trim()),
      };
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);

      await plantProvider.updatePlant(plantData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Plant updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating plant: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating plant: $e')),
      );
    }
    @override
    void dispose() {
      _nameController.dispose();
      _days_to_harvestController.dispose();
      super.dispose();
    }
  }
}
