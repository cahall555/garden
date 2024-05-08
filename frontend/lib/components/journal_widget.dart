import 'package:flutter/material.dart';
import '../model/journal.dart';

class JournalWidget extends StatelessWidget {
  const JournalWidget({
    required this.title,
//		required this.zone,
//		required this.description,
//		required this.garden,
  });

  final String title;
//	final String zone;
//	final String description;
//	final Garden garden;

  @override
  Widget build(BuildContext context) {
    const title = 'Horizontal List';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(title),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(vertical: 20),
          height: 200,
          child: ListView(
            // This next line does the trick.
            scrollDirection: Axis.horizontal,
            children: <Widget>[
              Container(
	        child: Text(title),
		width: 160.0,

              ),
            ],
          ),
        ),
      ),
    );
  }
}
