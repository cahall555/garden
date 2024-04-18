import 'package:flutter/material.dart';
import 'dart:async';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';
import '../provider/garden_provider.dart';
import 'package:provider/provider.dart';

class GardenCreate extends StatefulWidget {
  const GardenCreate({Key? key}) : super(key: key);

  @override
  State<GardenCreate> createState() => _GardenCreateState();
}

class _GardenCreateState extends State<GardenCreate> {
  final _nameController = TextEditingController();
  final _zoneController = TextEditingController();
  //final GardenApi gardenApi = GardenApi(); *** Leaving in for potential csrf see line 14 in app.go.

  @override
  Widget build(BuildContext context) {
    GardenProvider gardenProvider = Provider.of<GardenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Garden'),
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
              labelText: 'Zone',
              border: OutlineInputBorder(),
            ),
            controller: _zoneController,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              //	await gardenApi.initCsrfToken(); //see comment in app.go line 14
              if (_nameController.text.isNotEmpty &&
                  _zoneController.text.isNotEmpty) {
                submitGarden();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }

  void submitGarden() async {
    try {
      final gardenProvider =
          Provider.of<GardenProvider>(context, listen: false);
      await gardenProvider.createGarden({
        // await gardenApi.createGarden(gardenData); see comment in app.go line 14
        'name': _nameController.text.trim(),
        'zone': _zoneController.text.trim(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Garden updated successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create garden: $e')),
      );
    }
    @override
    void dispose() {
      _nameController.dispose();
      _zoneController.dispose();
      super.dispose();
    }
  }
}
