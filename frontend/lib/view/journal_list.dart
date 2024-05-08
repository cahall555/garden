import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../provider/journal_provider.dart';
import 'journal_create.dart';
import 'journal_detail.dart';

class JournalList extends StatefulWidget {
  @override
  _JournalListState createState() => _JournalListState();
}

class _JournalListState extends State<JournalList> {
  Future<List<Journal>>? futureJournal;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (futureJournal == null) {
      final journalProvider =
          Provider.of<JournalProvider>(context, listen: false);
      futureJournal = journalProvider.fetchJournal();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Journal Entries"),
      ),
      body: Consumer<JournalProvider>(
        builder: (context, journalProvider, child) {
          return Stack(
            children: <Widget>[
              FutureBuilder<List<Journal>>(
                future: futureJournal,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          elevation: 5,
                          margin: EdgeInsets.all(8),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JournalDetail(
                                      journal: snapshot.data![index]),
                                ),
                              );
                            },
                            leading: Icon(Icons.local_florist),
                            title: Text(
                              snapshot.data![index].title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                            subtitle: Text(snapshot.data![index].entry),
                            trailing: Icon(Icons.favorite),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("No journal entries found");
                  }
                },
              ),
              Positioned(
                bottom: 50,
                child: ElevatedButton(
                  onPressed: () {
                    //Navigator.push(
                    //context,
                    //MaterialPageRoute(builder: (context) => JournalCreate()));
                    Navigator.pop(context);
                  },
                  child: Text('Add Journal'),
                  style: ElevatedButton.styleFrom(
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
