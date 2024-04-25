import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../provider/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class JournalUpdate extends StatefulWidget {
  final Journal journal;

  const JournalUpdate({Key? key, required this.journal}) : super(key: key);

  @override
  State<JournalUpdate> createState() => _JournalUpdateState();
}

class _JournalUpdateState extends State<JournalUpdate> {
  late TextEditingController _titleController;
  late TextEditingController _entryController;
  String? _imagePath;
  bool _display_on_gardenController = false;
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
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.journal.title);
    _entryController = TextEditingController(text: widget.journal.entry);
    if (widget.journal.image != null && widget.journal.image!.isNotEmpty) {
      _imagePath = 'assets/' + widget.journal.image!;
    } else {
      _imagePath = "";
    }
    _display_on_gardenController = widget.journal.display_on_garden;
    _currentSelectedValue = widget.journal.category;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Journal'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
            controller: _titleController,
          ),
          const SizedBox(height: 20.0),
          TextField(
            decoration: InputDecoration(
              labelText: 'Entry',
              border: OutlineInputBorder(),
            ),
            controller: _entryController,
          ),
          GestureDetector(
            onTap: () => _pickImage(),
            child: _imagePath == _imagePath
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
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              labelText: "Category",
              border: OutlineInputBorder(),
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
              updateJournalInfo();
            },
            child: const Text('submit'),
          ),
        ],
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

  void updateJournalInfo() async {
    try {
      Map<String, dynamic> journalData = {
        'id': widget.journal.id,
        'title': _titleController.text.trim(),
        'entry': _entryController.text.trim(),
        'image': _imagePath,
        'category': _currentSelectedValue,
        'display_on_garden': _display_on_gardenController,
        'plant_id': widget.journal.plant_id,
      };
      final journalProvider =
          Provider.of<JournalProvider>(context, listen: false);

      var journalId = journalData['id'];
      var plantId = journalData['plant_id'];
      await journalProvider.updateJournal(journalData, journalId, plantId, _imagePath);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Journal updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating journal: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating journal: $e')),
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
