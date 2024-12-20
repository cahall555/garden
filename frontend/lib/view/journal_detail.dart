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
        title:
            Text(widget.journal.title, style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/journal.webp"),
                fit: BoxFit.cover,
                opacity: 0.15,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 120),
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
                            title: Text(
                                'Journal Category: ' + widget.journal.category,
                                style: TextStyle(
                                    fontFamily: 'Taviraj',
                                    fontWeight: FontWeight.normal)),
                            subtitle: Text(widget.journal.entry),
                          ),
                          if (widget.journal.image == null ||
                              widget.journal.image!.isEmpty)
                            const Text('Image not availabile')
                          else
                            Image.asset(
                              '${widget.journal.image!}',
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (BuildContext context,
                                  Object exception, StackTrace? stackTrace) {
                                return const Text('Image not available');
                              },
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildButton(
                    text: 'Update Journal',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => JournalUpdate(
                              journal: widget.journal, plant: widget.plant),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 10),
                  _buildButton(
                    text: 'Delete Journal',
                    onPressed: () {
                      try {
                        Provider.of<JournalProvider>(context, listen: false)
                            .deleteJournal(widget.journal);
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButton({required String text, required VoidCallback onPressed}) {
    return ElevatedButton(
      style: ButtonStyle(
        elevation: MaterialStateProperty.all<double>(12.0),
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
      ),
      onPressed: onPressed,
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
          constraints: BoxConstraints(minWidth: 108.0, minHeight: 45.0),
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontFamily: 'Taviraj',
            ),
          ),
        ),
      ),
    );
  }
}
