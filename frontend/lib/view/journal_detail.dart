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

class JournalDetail extends StatefulWidget {
  final Journal journal;
  final Plant plant;

  JournalDetail({Key? key, required this.journal, required this.plant})
      : super(key: key);

  @override
  _JournalDetailState createState() => _JournalDetailState();
}

class _JournalDetailState extends State<JournalDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.journal.title, style: TextStyle(fontFamily: 'Taviraj')),
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
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        title: Text(widget.journal.category),
                        subtitle: Text(widget.journal.entry),
                      ),
                      if (widget.journal.image != "")
                        Image.asset(
                          'assets/' + widget.journal.image!,
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
                          builder: (context) =>
                              JournalUpdate(journal: widget.journal, plant: widget.plant)),
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
                          .deleteJournal(widget.journal.id);
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
