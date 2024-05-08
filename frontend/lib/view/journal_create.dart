import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../model/plant.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../provider/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class JournalCreate extends StatefulWidget {
  final Plant plant;
  const JournalCreate({Key? key, required this.plant}) : super(key: key);

  @override
  State<JournalCreate> createState() => _JournalCreateState();
}

class _JournalCreateState extends State<JournalCreate> {
  final _titleController = TextEditingController();
  final _entryController = TextEditingController();
  String? _imagePath = null;
  bool _display_on_gardenController = false;
  final _plant_idController = TextEditingController();
  String? _currentSelectedValue;
  final List<String> _dropdownValues = [
    "Pests",
    "Planting",
    "Watering",
    "Pruning",
    "Harvesting",
    "Weather",
    "Germination"
  ];

  @override
  Widget build(BuildContext context) {
    JournalProvider journalProvider = Provider.of<JournalProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Journal', style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/journal.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(
                  color: Color(0XFF8E505F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Title',
                labelStyle:
                    TextStyle(color: Color(0XFF2A203D), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF2A203D))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF2A203D)),
                ),
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              maxLines: 10,
              style: TextStyle(
                  color: Color(0XFF8E505F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Entry',
                labelStyle:
                    TextStyle(color: Color(0XFF2A203D), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF2A203D))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF2A203D)),
                ),
              ),
              controller: _entryController,
            ),
            const SizedBox(height: 20.0),
            GestureDetector(
              onTap: () => _pickImage(),
              child: _imagePath == null
                  ? Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0XFF2A203D)),
                      ),
                      child: Icon(Icons.add_a_photo, color: Color(0XFF8E505F)),
                    )
                  : Image.file(File(_imagePath!)),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              style: TextStyle(color: Color(0xFF8E505F), fontFamily: 'Taviraj'),
              decoration: InputDecoration(
                labelText: "Category",
                labelStyle:
                    TextStyle(color: Color(0xFF2A203D), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFF2A203D))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF2A203D)),
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
                              ? Color(0xFF8E505F)
                              : Color(0xFF2A203D),
                          fontFamily: 'Taviraj',
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0)),
                );
              }).toList(),
            ),
            ListTile(
              leading: const Text('Display in Garden',
                  style: TextStyle(
                      color: Color(0XFF2A203D),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Taviraj')),
              trailing: Switch(
                activeColor: Color(0XFF2A203D),
                activeTrackColor: Color(0XFF8E505F),
                value: _display_on_gardenController,
                onChanged: (bool value) {
                  setState(() {
                    _display_on_gardenController = value;
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
                if (_titleController.text.isNotEmpty &&
                    _entryController.text.isNotEmpty) {
                  submitJournal();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Please ensure title and entry are complete.')),
                  );
                }
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

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _imagePath = image.path;
      });
    }
  }

  void submitJournal() async {
    try {
      final journalProvider =
          Provider.of<JournalProvider>(context, listen: false);
      await journalProvider.createJournal({
        'title': _titleController.text.trim(),
        'entry': _entryController.text.trim(),
        'image': _imagePath,
        'category': _currentSelectedValue,
        'display_in_garden': _display_on_gardenController,
        'plant_id': widget.plant.id,
      }, widget.plant.id, _imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journal created successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create journal: $e')),
      );
    }
    @override
    void dispose() {
      _titleController.dispose();
      _entryController.dispose();
      super.dispose();
    }
  }
}
