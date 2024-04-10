import 'package:flutter/material.dart';
import 'dart:async';
import '../model/plant.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';
import '../provider/ws_provider.dart';
import 'package:provider/provider.dart';

class WsUpdate extends StatefulWidget {
  final Plant plant;
  final WaterSchedule ws;
  const WsUpdate({Key? key, required this.plant, required this.ws}) : super(key: key);

  @override
  State<WsUpdate> createState() => _WsUpdateState();
}

class _WsUpdateState extends State<WsUpdate> {
	bool _mondayController = false;
	bool _tuesdayController = false;
	bool _wednesdayController = false;
	bool _thursdayController = false;
	bool _fridayController = false;
	bool _saturdayController = false;
	bool _sundayController = false;
  	late TextEditingController _notesController;
	String? _currentSelectedValue;
  	final List<String> _dropdownValues = ["Drip", "Hand Watering", "Sprinkler", "Soaker Hose"];

@override
  void initState() {
    super.initState();
    	_mondayController = widget.ws.monday;
	_tuesdayController = widget.ws.tuesday;
	_wednesdayController = widget.ws.wednesday;
	_thursdayController = widget.ws.thursday;
	_fridayController = widget.ws.friday;
	_saturdayController = widget.ws.saturday;
	_sundayController = widget.ws.sunday;
  	_notesController = TextEditingController(text: widget.ws.notes);
	_currentSelectedValue = widget.ws.method;
  }


  @override
  Widget build(BuildContext context) {
  WsProvider wsProvider = Provider.of<WsProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Water Schedule'),
      ),
      body: ListView(
      	padding: const EdgeInsets.all(20),
          children: <Widget>[
           ListTile(
            leading: const Text('Monday'),
            trailing: Switch(
              value: _mondayController,
              onChanged: (bool value) {
                setState(() {
                  _mondayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Tuesday'),
            trailing: Switch(
              value: _tuesdayController,
              onChanged: (bool value) {
                setState(() {
                  _tuesdayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Wednesday'),
            trailing: Switch(
              value: _wednesdayController,
              onChanged: (bool value) {
                setState(() {
                  _wednesdayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Thursday'),
            trailing: Switch(
              value: _thursdayController,
              onChanged: (bool value) {
                setState(() {
                  _thursdayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Friday'),
            trailing: Switch(
              value: _fridayController,
              onChanged: (bool value) {
                setState(() {
                  _fridayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Saturday'),
            trailing: Switch(
              value: _saturdayController,
              onChanged: (bool value) {
                setState(() {
                  _saturdayController = value;
                });
		},
		),
		),
	ListTile(
            leading: const Text('Sunday'),
            trailing: Switch(
              value: _sundayController,
              onChanged: (bool value) {
                setState(() {
                  _sundayController = value;
                });
		},
		),
		),
	   DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Watering Method",
              border: OutlineInputBorder(),
            ),
            value: _currentSelectedValue,
            onChanged: (String? newValue) {
              setState(() {
                _currentSelectedValue = newValue;
              });
            },
            items: _dropdownValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
	   TextField(
              decoration: InputDecoration(
                labelText: 'Notes',
		border: OutlineInputBorder(),
              ),
	      controller: _notesController,
            ),
	    const SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
			
			if (_notesController.text.isNotEmpty && (_currentSelectedValue?.isNotEmpty ?? false)) {
      				updateWaterSchedule();
    			} else {
      				ScaffoldMessenger.of(context).showSnackBar(
        				SnackBar(content: Text('Please ensure notes and method are complete.')),
      				);			
			}
			},
			child: const Text('submit'),
			),
          ],
	  ),
    );
  }
 void updateWaterSchedule() async {
  try {
	final wsProvider = Provider.of<WsProvider>(context, listen: false);
    await wsProvider.updateWs({
      'id': widget.ws.id,
      'monday': _mondayController,
      'tuesday': _tuesdayController,
      'wednesday': _wednesdayController,
      'thursday': _thursdayController,
      'friday': _fridayController,
      'saturday': _saturdayController,
      'sunday': _sundayController,
      'plant_id': widget.plant.id,
      'method': _currentSelectedValue,
      'notes': _notesController.text.trim(),
    }, widget.plant.id, widget.ws.id);
	ScaffoldMessenger.of(context).showSnackBar(
        	SnackBar(content: Text('Water schedule updated successfully!')),
      	);
    Navigator.pop(context); 
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to update water schedule: $e')),
    );
  }
  	@override
	void dispose() {
  	_notesController.dispose();
  	super.dispose();
	}

}

}
