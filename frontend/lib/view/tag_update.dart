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
        title: Text('Update Tag'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
            ),
            controller: _nameController,
          ),
          const SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: () {
              updateTagInfo();
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }

  void updateTagInfo() async {
    try {
      Map<String, dynamic> tagData = {
        'id': widget.tag.id,
        'name': _nameController.text.trim(),
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
