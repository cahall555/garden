import 'package:flutter/material.dart';
import 'dart:async';
import '../model/plant.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';
import '../provider/tag_provider.dart';
import '../provider/plants_tag_provider.dart';
import 'package:provider/provider.dart';

class TagCreate extends StatefulWidget {
  final Plant? plant;
  const TagCreate({Key? key, this.plant}) : super(key: key);

  @override
  State<TagCreate> createState() => _TagCreateState();
}

class _TagCreateState extends State<TagCreate> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    TagProvider tagProvider = Provider.of<TagProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Tag'),
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
              if (_nameController.text.isNotEmpty) {
                submitTag();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in all fields')),
                );
              }
            },
            child: const Text('submit'),
          ),
        ],
      ),
    );
  }

  void submitTag() async {
    try {
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      if (widget.plant != null) {
        Tag? existingTag =
            await tagProvider.fetchTagByName(_nameController.text.trim());
        if (existingTag != null) {
          PlantsTagProvider plantsTagProvider =
              Provider.of<PlantsTagProvider>(context, listen: false);
          await plantsTagProvider.createPlantsTag({
            'plant_id': widget.plant!.id,
            'tag_id': existingTag.id,
          });
        } else {
          Tag newTag = await tagProvider.createTag({
            'name': _nameController.text.trim(),
          });
          var tagid = newTag.id;
          PlantsTagProvider plantsTagProvider =
              Provider.of<PlantsTagProvider>(context, listen: false);

          await plantsTagProvider.createPlantsTag({
            'plant_id': widget.plant!.id,
            'tag_id': tagid,
          });
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tag updated successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create tag: $e')),
      );
    }
    @override
    void dispose() {
      _nameController.dispose();
      super.dispose();
    }
  }
}
