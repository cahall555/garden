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
  late TextEditingController _plant_countController;
  late TextEditingController _date_plantedController;
  late TextEditingController _date_germinatedController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.plant.name);
    _germinatedController = widget.plant.germinated;
    _days_to_harvestController =
        TextEditingController(text: widget.plant.days_to_harvest.toString());
    _plant_countController =
        TextEditingController(text: widget.plant.plant_count.toString());
    _date_plantedController =
        TextEditingController(text: widget.plant.date_planted.toString());
    _date_germinatedController =
        TextEditingController(text: widget.plant.date_germinated.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Plant', style: TextStyle(fontFamily: 'Taviraj')),
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
              style: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: 'Days to Harvest',
                border: OutlineInputBorder(),
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              ),
              controller: _days_to_harvestController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: 'Plant Count',
                border: OutlineInputBorder(),
                labelStyle:
                    TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              ),
              controller: _plant_countController,
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
              leadingAndTrailingTextStyle: TextStyle(
                  color: Colors.white, fontSize: 15.0, fontFamily: 'Taviraj'),
              leading: const Text('Plant has germinated'),
              trailing: Switch(
                activeColor: Color(0xFF2A203D),
                activeTrackColor: Color(0xFF8E505F),
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
              style: ButtonStyle(
                elevation: MaterialStateProperty.all<double>(12.0),
                backgroundColor:
                    MaterialStateProperty.all<Color>(Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
              onPressed: () {
                updatePlantInfo();
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF8E505F),
                      Color(0xFF2A203D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                  alignment: Alignment.center,
                  child: const Text('Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontFamily: 'Taviraj')),
                ),
              ),
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

  void updatePlantInfo() async {
    try {
      Map<String, dynamic> plantData = {
        'id': widget.plant.id,
        'name': _nameController.text.trim(),
        'germinated': _germinatedController,
        'garden_id': widget.plant.garden_id,
        'days_to_harvest': int.parse(_days_to_harvestController.text.trim()),
        'plant_count': int.parse(_plant_countController.text.trim()),
        'date_planted': _date_plantedController.text.trim(),
        'date_germinated': _date_germinatedController.text.trim(),
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
      _plant_countController.dispose();
      _date_plantedController.dispose();
      _date_germinatedController.dispose();
      super.dispose();
    }
  }
}
