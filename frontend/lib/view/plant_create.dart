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
  final _plant_countController = TextEditingController();
  final _date_plantedController = TextEditingController();
  final _date_germinatedController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    PlantProvider plantProvider = Provider.of<PlantProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Plant'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF344E41),
              Color(0xFF78B496),
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Days to Harvest',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _days_to_harvestController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Plant Count',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _plant_countController,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextField(
              readOnly: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Date Planted',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _date_plantedController,
              onTap: () async {
                DateTime? pickedDate = await _selectDate(context);
                if (pickedDate != null) {
                  setState(() {
                    _date_plantedController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
            const SizedBox(height: 20.0),
            TextField(
              readOnly: true,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: 'Date Germinated',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _date_germinatedController,
              onTap: () async {
                DateTime? pickedDate = await _selectDate(context);
                if (pickedDate != null) {
                  setState(() {
                    _date_germinatedController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
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
      ),
    );
  }

  Future<DateTime?> _selectDate(BuildContext context) async {
    DateTime initialDate = DateTime.now();
    DateTime firstDate = DateTime(2000);
    DateTime lastDate = DateTime(2101);
    return showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
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
      final plantCount = int.tryParse(_plant_countController.text) ?? 0;
      if (plantCount <= 0) {
        print('number must be greater than zero');
        return;
      }
      final plantProvider = Provider.of<PlantProvider>(context, listen: false);
      await plantProvider.createPlant({
        'name': _nameController.text.trim(),
        'days_to_harvest': daysToHarvest,
        'germinated': _germinatedController,
        'plant_count': plantCount,
        'date_planted': _date_plantedController.text.trim(),
        'date_germinated': _date_germinatedController.text.trim(),
        'garden_id': widget.garden.id,
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
      _plant_countController.dispose();
      _date_plantedController.dispose();
      _date_germinatedController.dispose();
      super.dispose();
    }
  }
}
