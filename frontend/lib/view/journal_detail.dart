import 'package:flutter/material.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import 'plant_detail.dart';
import 'journal_create.dart';
import '../provider/journal_provider.dart';
import '../provider/plant_provider.dart';
import 'package:provider/provider.dart';

class JournalDetail extends StatelessWidget {
  final Journal journal;

  JournalDetail({Key? key, required this.journal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(journal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(journal.category),
                    //leading: Image.asset(journal.image),
                    subtitle: Text(journal.entry),
                  ),
                  //Image.asset(
                  //  journal.image,
                  //width: double.infinity,
                  //fit: BoxFit.cover,
                  //),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  //Navigator.push(
                  //context,
                  //MaterialPageRoute(builder: (context) => JournalUpdate()),
                  //);
                  Navigator.pop(context);
                },
                child: Text('Update Journal'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  // Call delete garden method
                  // For example, using Provider to delete garden
                  // Provider.of<GardenProvider>(context, listen: false).deleteGarden(garden.id);
                  // Then pop back
                  Navigator.of(context).pop();
                },
                child: Text('Delete Journal'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
