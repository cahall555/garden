import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import '../model/journal.dart';
import '../model/plant.dart';
import '../model/apis/journal_api.dart';
import '../provider/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:frontend/components/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';

class JournalUpdate extends StatefulWidget {
  final Journal journal;
  final Plant plant;

  const JournalUpdate({Key? key, required this.journal, required this.plant})
      : super(key: key);

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
      _imagePath = widget.journal.image!;
    } else {
      _imagePath = "";
    }
    _display_on_gardenController = widget.journal.display_on_garden;
    _currentSelectedValue = widget.journal.category;
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: TextSelectionThemeData(
          selectionHandleColor: Color(0XFF8E505F),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title:
              Text('Update Journal', style: TextStyle(fontFamily: 'Taviraj')),
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
              TextField(
                style: TextStyle(
                    color: Color(0XFF8E505F),
                    fontFamily: 'Taviraj',
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(
                      color: Color(0XFF2A203D), fontFamily: 'Taviraj'),
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
                  labelStyle: TextStyle(
                      color: Color(0XFF2A203D), fontFamily: 'Taviraj'),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0XFF2A203D))),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF2A203D)),
                  ),
                ),
                controller: _entryController,
              ),
              const SizedBox(height: 20.0),
              Container(
                height: 150,
                width: double.infinity,
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFF2A203D)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: _imagePath == _imagePath
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            onTap: () => _pickImage(),
                            child: Icon(Icons.camera_roll_rounded,
                                color: Color(0xFF8E505F)),
                          ),
                          GestureDetector(
                            onTap: () async {
                              List<CameraDescription> cameras =
                                  await availableCameras();
                              final result = await Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => CameraApp(
                                          cameras: cameras,
                                          plant: this.widget.plant!)));
                              if (result != null) {
				      try {
					      final directory = await getApplicationDocumentsDirectory();
					      final newFilePath = '${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

					      final File imageFile = File(result);
					      final newImageFile = await imageFile.copy(newFilePath);

					      print('Image saved to: $newFilePath');
                                setState(() {
                                  _imagePath = newImageFile.path;
                                });
				      } catch (e) {
					      print('Error saving image to application document directory: $e');
				      }
                              }
                            },
                            child: Icon(Icons.add_a_photo,
                                color: Color(0xFF8E505F)),
                          ),
                        ],
                      )
                    : Image.file(File(_imagePath!)),
              ),
              const SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                style:
                    TextStyle(color: Color(0xFF8E505F), fontFamily: 'Taviraj'),
                decoration: InputDecoration(
                  labelText: "Category",
                  labelStyle: TextStyle(
                      color: Color(0xFF2A203D), fontFamily: 'Taviraj'),
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
                items: _dropdownValues
                    .map<DropdownMenuItem<String>>((String value) {
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
                  inactiveThumbColor: Color(0xFF2A203D),
                  inactiveTrackColor: Colors.grey[400],
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
                  updateJournalInfo();
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
                    constraints:
                        BoxConstraints(minWidth: 108.0, minHeight: 45.0),
                    alignment: Alignment.center,
                    child: const Text('Submit',
                        key: Key('updateJournalButton'),
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
      await journalProvider.updateJournal(
          journalData, journalId, plantId, _imagePath);
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
