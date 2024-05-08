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
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: 'Days to Harvest',
                border: OutlineInputBorder(),
                labelStyle: TextStyle(color: Colors.white, fontFamily: 'Taviraj'),
              ),
              controller: _days_to_harvestController,
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
                backgroundColor: MaterialStateProperty.all<Color>(
                    Colors.transparent),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        25.0),
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
                  borderRadius: BorderRadius.circular(
                      25.0),
                ),
                child: Container(
                  constraints: BoxConstraints(
                      minWidth: 108.0,
                      minHeight: 45.0),
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
