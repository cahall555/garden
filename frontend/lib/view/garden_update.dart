import 'package:flutter/material.dart';
import 'dart:async';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';

class GardenUpdate extends StatefulWidget {
  final Garden garden;
  //final Function(Garden) onUpdateSuccess;
  const GardenUpdate({Key? key, required this.garden}) : super(key: key);

  @override
  State<GardenUpdate> createState() => _GardenUpdateState();
}

class _GardenUpdateState extends State<GardenUpdate> {
	late TextEditingController _nameController;
        late TextEditingController _zoneController;
	//Future<Garden>? _futureGarden;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.garden.name);
    _zoneController = TextEditingController(text: widget.garden.zone);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Garden'),
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
			updateGardenInfo();
			},
			child: const Text('submit'),
			),
          ],
	  ),
    );
  }
  void updateGardenInfo() async {
    try {
      Map<String, dynamic> gardenData = {
        'id': widget.garden.id,
        'name': _nameController.text.trim(),
        'zone': _zoneController.text.trim(),
      };
      
	var gardenId = gardenData['id'];
	 await updateGarden(gardenData, gardenId);
//     setState(() {
  //   	_futureGarden = {updatedGardenData['name'], updatedGardenData['zone']} 
      
//	});
     // widget.onUpdateSuccess(updatedGarden);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Garden updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating garden: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating garden: $e')),
      );
    }
  }
}
