import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../model/plant.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';
import '../provider/ws_provider.dart';
import 'package:provider/provider.dart';

class WsCreate extends StatefulWidget {
  final Plant plant;
  const WsCreate({Key? key, required this.plant}) : super(key: key);

  @override
  State<WsCreate> createState() => _WsCreateState();
}

class _WsCreateState extends State<WsCreate> {
  bool _mondayController = false;
  bool _tuesdayController = false;
  bool _wednesdayController = false;
  bool _thursdayController = false;
  bool _fridayController = false;
  bool _saturdayController = false;
  bool _sundayController = false;
  final _notesController = TextEditingController();
  String? _currentSelectedValue;
  final List<String> _dropdownValues = [
    "Drip",
    "Hand Watering",
    "Sprinkler",
    "Soaker Hose"
  ];
  var uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    WsProvider wsProvider = Provider.of<WsProvider>(context);
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Color(0XFF263B61),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create Water Schedule',
              style: TextStyle(fontFamily: 'Taviraj')),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/water.webp"),
              fit: BoxFit.cover,
              opacity: 0.15,
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: <Widget>[
              ListTile(
                leading: const Text('Monday',
                    style: TextStyle(
                        color: Color(0XFF4E7AC7),
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
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
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Taviraj')),
                trailing: Switch(
                  activeColor: Color(0xFF263B61),
                  activeTrackColor: Color(0xFF4E7AC7),
                  inactiveThumbColor: Color(0xFF263B61),
                  inactiveTrackColor: Colors.grey[400],
                  value: _sundayController,
                  onChanged: (bool value) {
                    setState(() {
                      _sundayController = value;
                    });
                  },
                ),
              ),
              DropdownButtonFormField<String>(
                style:
                    TextStyle(color: Color(0xFF263B61), fontFamily: 'Taviraj'),
                decoration: InputDecoration(
                  labelText: "Watering Method",
                  labelStyle: TextStyle(
                      color: Color(0xFF263B61), fontFamily: 'Taviraj'),
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
                items: _dropdownValues
                    .map<DropdownMenuItem<String>>((String value) {
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
                  labelStyle: TextStyle(
                      color: Color(0XFF263B61), fontFamily: 'Taviraj'),
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
                    submitWaterSchedule();
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
                    constraints:
                        BoxConstraints(minWidth: 108.0, minHeight: 45.0),
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
      ),
    );
  }

  void submitWaterSchedule() async {
    try {
      final wsProvider = Provider.of<WsProvider>(context, listen: false);
      await wsProvider.createWs({
        'id': uuid.v1(),
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
      }, widget.plant.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Water schedule created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create water schedule: $e')),
      );
    }
    @override
    void dispose() {
      _notesController.dispose();
      super.dispose();
    }
  }
}
