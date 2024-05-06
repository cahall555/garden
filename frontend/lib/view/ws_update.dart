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
  const WsUpdate({Key? key, required this.plant, required this.ws})
      : super(key: key);

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
  final List<String> _dropdownValues = [
    "Drip",
    "Hand Watering",
    "Sprinkler",
    "Soaker Hose"
  ];

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
        title: Text('Update Water Schedule',
            style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/water.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),

//          gradient: LinearGradient(
//            begin: Alignment.topLeft,
//            end: Alignment.bottomRight,
//            colors: [
//              Color(0xFF263B61),
//              Color(0xFF4E7AC7),
//            ],
//          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              leading: const Text('Monday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _mondayController,
                onChanged: (bool value) {
                  setState(() {
                    _mondayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Tuesday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _tuesdayController,
                onChanged: (bool value) {
                  setState(() {
                    _tuesdayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Wednesday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _wednesdayController,
                onChanged: (bool value) {
                  setState(() {
                    _wednesdayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Thursday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _thursdayController,
                onChanged: (bool value) {
                  setState(() {
                    _thursdayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Friday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _fridayController,
                onChanged: (bool value) {
                  setState(() {
                    _fridayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Saturday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _saturdayController,
                onChanged: (bool value) {
                  setState(() {
                    _saturdayController = value;
                  });
                },
              ),
            ),
            ListTile(
              leading: const Text('Sunday',
                  style: TextStyle(
                      color: Color(0XFF4E7AC7),
                      fontFamily: 'Taviraj',
                      fontWeight: FontWeight.bold,
                      fontSize: 15)),
              trailing: Switch(
                activeColor: Color(0xFF263B61),
                activeTrackColor: Color(0xFF4E7AC7),
                value: _sundayController,
                onChanged: (bool value) {
                  setState(() {
                    _sundayController = value;
                  });
                },
              ),
            ),
            DropdownButtonFormField<String>(
              style: TextStyle(color: Color(0xFF263B61), fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: "Watering Method",
                labelStyle:
                    TextStyle(color: Color(0xFF263B61), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF263B61))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF263B61)),
                ),
              ),
              value: _currentSelectedValue,
              onChanged: (String? newValue) {
                setState(() {
                  _currentSelectedValue = newValue;
                });
              },
              items:
                  _dropdownValues.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,
                      style: TextStyle(
                          color: _currentSelectedValue == value
                              ? Color(0xFF4E7AC7)
                              : Color(0xFF263B61),
                          fontFamily: 'Taviraj',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                );
              }).toList(),
            ),
            const SizedBox(height: 20.0),
            TextField(
              maxLines: 10,
              style: TextStyle(
                  color: Color(0XFF4E7AC7),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Notes',
                labelStyle:
                    TextStyle(color: Color(0XFF263B61), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF263B61))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF263B61)),
                ),
              ),
              controller: _notesController,
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
                if (_notesController.text.isNotEmpty &&
                    (_currentSelectedValue?.isNotEmpty ?? false)) {
                  updateWaterSchedule();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please ensure notes and method are complete.')),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4E7AC7),
                      Color(0xFF263B61),
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
              onPressed: () async {
                try {
                  final wsProvider =
                      Provider.of<WsProvider>(context, listen: false);
                  await wsProvider.deleteWs(widget.ws.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Schedule successfully deleted.')),
                  );
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to delete water schedule: $e.')),
                  );
                }
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF4E7AC7),
                      Color(0xFF263B61),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25.0),
                ),
                child: Container(
                  constraints: BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                  alignment: Alignment.center,
                  child: const Text('Delete Water Schedule',
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
