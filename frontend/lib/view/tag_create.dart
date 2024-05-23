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
        title: Text('Create Tag', style: TextStyle(fontFamily: 'Taviraj')),
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
                if (_nameController.text.isNotEmpty) {
                  submitTag();
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

  void submitTag() async {
    try {

      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      if (widget.plant != null) {
        Tag? existingTag =
            await tagProvider.fetchTagByName(_nameController.text.trim(), widget.plant!.account_id);
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
	    'account_id': widget.plant!.account_id,
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
