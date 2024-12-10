import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../model/garden.dart';
import '../model/account.dart';
import '../model/users_account.dart';
import 'garden_list.dart';
import '../model/apis/garden_api.dart';
import '../provider/garden_provider.dart';
import 'package:provider/provider.dart';

class GardenCreate extends StatefulWidget {
  //final Account account;
  final UserAccounts userAccounts;
  const GardenCreate({Key? key, required this.userAccounts}) : super(key: key);

  @override
  State<GardenCreate> createState() => _GardenCreateState();
}

class _GardenCreateState extends State<GardenCreate> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  var uuid = Uuid();
  //final GardenApi gardenApi = GardenApi(); *** Leaving in for potential csrf see line 14 in app.go.

  @override
  Widget build(BuildContext context) {
    GardenProvider gardenProvider = Provider.of<GardenProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Garden', style: TextStyle(fontFamily: 'Taviraj')),
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
                //	await gardenApi.initCsrfToken(); //see comment in app.go line 14
                if (_nameController.text.isNotEmpty &&
                    _descriptionController.text.isNotEmpty) {
                  submitGarden();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill in all fields')),
                  );
                }
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

  void submitGarden() async {
    try {
      final gardenProvider =
          Provider.of<GardenProvider>(context, listen: false);
      await gardenProvider.createGarden({
        // await gardenApi.createGarden(gardenData); see comment in app.go line 14
	'id': uuid.v1(),
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'account_id': widget.userAccounts!.account_id,
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Garden updated successfully!')),
      );
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GardenList(userAccounts: widget.userAccounts),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create garden: $e')),
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
