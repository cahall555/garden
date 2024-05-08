import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import 'plant_detail.dart';
import 'journal_create.dart';
import 'journal_update.dart';
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
        title: Text(journal.title, style: TextStyle(fontFamily: 'Taviraj')),
      ),
 body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/journal.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
	),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Card(
              elevation: 5,
	      margin: EdgeInsets.all(8),
	      child: Padding(padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  ListTile(
                    title: Text(journal.category),
                    subtitle: Text(journal.entry),
                  ),
                  if (journal.image != "")
                    Image.asset(
                      'assets/' + journal.image!,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (BuildContext context, Object exception,
                          StackTrace? stackTrace) {
                        return const Text('Image not available');
                      },
                    ),
                ],
              ),
            ),
	    ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => JournalUpdate(journal: journal)),
                  );
                },
                child: Text('Update Journal'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {
                  try {
                    Provider.of<JournalProvider>(context, listen: false)
                        .deleteJournal(journal.id);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Journal deleted successfully'),
                    ));
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Failed to delete journal: $e'),
                    ));
                  }
                },
                child: Text('Delete Journal'),
              ),
            ),
          ],
        ),
	),
      ),
    );
  }
}
