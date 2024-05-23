import 'package:flutter/material.dart';
import 'dart:async';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
import '../provider/tag_provider.dart';
import 'package:provider/provider.dart';

class TagUpdate extends StatefulWidget {
  final Tag tag;
  const TagUpdate({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagUpdate> createState() => _TagUpdateState();
}

class _TagUpdateState extends State<TagUpdate> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.tag.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Tag', style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/tag.webp"),
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
                updateTagInfo();
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

  void updateTagInfo() async {
    try {
      Map<String, dynamic> tagData = {
        'id': widget.tag.id,
        'name': _nameController.text.trim(),
	'account_id': widget.tag.account_id,
      };
      final tagProvider = Provider.of<TagProvider>(context, listen: false);

      var tagId = tagData['id'];
      await tagProvider.updateTag(tagData, tagId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Tag updated successfully!')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print('Error updating tag: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating tag: $e')),
      );
    }
  }
}
