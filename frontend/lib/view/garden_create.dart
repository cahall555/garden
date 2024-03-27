import 'package:flutter/material.dart';
import 'dart:async';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';

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
                onPressed: () async {
		//	await gardenApi.initCsrfToken(); //see comment in app.go line 14
			try{
			 	Map<String, dynamic> gardenData = {
					'name': _nameController.text.trim(),
					'zone': _zoneController.text.trim(),
				};
				await createGarden(gardenData); // await gardenApi.createGarden(gardenData); see comment in app.go line 14
			} catch (e) {
				print('error creating garden: $e');
			}
			},
			child: const Text('submit'),
			),
          ],
	  ),
    );
  }
}
