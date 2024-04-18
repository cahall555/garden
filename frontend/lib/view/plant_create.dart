import 'package:flutter/material.dart';
import 'dart:async';
import '../model/plant.dart';
import '../model/garden.dart';
import '../model/apis/plant_api.dart';
import '../provider/plant_provider.dart';
import 'package:provider/provider.dart';

class PlantCreate extends StatefulWidget {
  final Garden garden;
  const PlantCreate({Key? key, required this.garden}) : super(key: key);

  @override
  State<PlantCreate> createState() => _PlantCreateState();
}

class _PlantCreateState extends State<PlantCreate> {
  final _nameController = TextEditingController();
  bool _germinatedController = false;
  final _days_to_harvestController = TextEditingController();
  final _tagsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PlantProvider plantProvider = Provider.of<PlantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plant'),
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
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20.0),
          ListTile(
            leading: const Text('Germinated'),
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
          TextField(
            decoration: InputDecoration(
              labelText: 'Tags',
              border: OutlineInputBorder(),
            ),
            controller: _tagsController,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _days_to_harvestController.text.isNotEmpty) {
                submitPlant();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all text fields')),
                );
              }
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }

  void submitPlant() async {
    try {
      final int daysToHarvest =
          int.tryParse(_days_to_harvestController.text) ?? 0;
      if (daysToHarvest <= 0) {
        print('number must be greater than zero');
        return;
      }
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      await plantProvider.createPlant({
        'name': _nameController.text.trim(),
        'days_to_harvest': daysToHarvest,
        'germinated': _germinatedController,
        'garden_id': widget.garden.id,
        'tags': _tagsController.text.trim(),
      }, widget.garden.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Plant created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create plant: $e')),
      );
    }
    @override
    void dispose() {
      _nameController.dispose();
      _days_to_harvestController.dispose();
      _tagsController.dispose();
      super.dispose();
    }
  }
}
