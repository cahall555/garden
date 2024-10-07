import 'package:flutter/material.dart';
import 'dart:async';
import '../model/garden.dart';
import '../model/users_account.dart';
import '../model/apis/garden_api.dart';
import '../provider/garden_provider.dart';
import 'package:provider/provider.dart';

class GardenUpdate extends StatefulWidget {
  final Garden garden;
  final UserAccounts userAccounts;
  const GardenUpdate(
      {Key? key, required this.garden, required this.userAccounts})
      : super(key: key);

  @override
  State<GardenUpdate> createState() => _GardenUpdateState();
}

class _GardenUpdateState extends State<GardenUpdate> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.garden.name);
    _descriptionController =
        TextEditingController(text: widget.garden.description);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Garden', style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/garden.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            TextField(
              style: TextStyle(
                  color: Color(0XFF987D3F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle:
                    TextStyle(color: Color(0XFF987D3F), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF987D3F))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF987D3F)),
                ),
              ),
              controller: _nameController,
            ),
            const SizedBox(height: 20.0),
            TextField(
              style: TextStyle(
                  color: Color(0XFF987D3F),
                  fontFamily: 'Taviraj',
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle:
                    TextStyle(color: Color(0XFF987D3F), fontFamily: 'Taviraj'),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0XFF987D3F))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0XFF987D3F)),
                ),
              ),
              controller: _descriptionController,
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
                updateGardenInfo();
              },
              child: Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFED16A),
                      Color(0xFF987D3F),
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

  void updateGardenInfo() async {
    try {
      Map<String, dynamic> gardenData = {
        'id': widget.garden.id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'account_id': widget.userAccounts.account_id,
      };
      final gardenProvider =
          Provider.of<GardenProvider>(context, listen: false);

      var gardenId = gardenData['id'];
      await gardenProvider.updateGarden(gardenData, gardenId);
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

    @override
    void dispose() {
      _nameController.dispose();
      _descriptionController.dispose();
      super.dispose();
    }
  }
}
