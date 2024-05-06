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
        title: Text('Create Journal'),
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
            const SizedBox(height: 20.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
		labelStyle: TextStyle(color: Colors.white),
              ),
              controller: _titleController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              maxLines: 10,
              decoration: InputDecoration(
                labelText: 'Entry',
                border: OutlineInputBorder(),
		labelStyle: TextStyle(color: Colors.white),
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
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Icon(Icons.add_a_photo),
                    )
                  : Image.file(File(_imagePath!)),
            ),
            const SizedBox(height: 20.0),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
		labelStyle: TextStyle(color: Colors.white),
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
                  child: Text(value),
                );
              }).toList(),
            ),
            ListTile(
              leading: const Text('Display in Garden'),
              trailing: Switch(
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
              child: const Text('Submit'),
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
