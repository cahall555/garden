import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
import '../model/users_account.dart';
import 'tag_create.dart';
import 'tag_detail.dart';
import '../provider/tag_provider.dart';

class TagList extends StatefulWidget {
  final UserAccounts userAccounts;
  const TagList({Key? key, required this.userAccounts}) : super(key: key);

  @override
  _TagListState createState() => _TagListState();
}

class _TagListState extends State<TagList> {
  Future<List<Tag>>? futureTag;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (futureTag == null) {
      var accountId = widget.userAccounts.account_id;
      final tagProvider = Provider.of<TagProvider>(context, listen: false);
      futureTag = tagProvider.fetchTags(accountId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tags"),
      ),
      body: Consumer<TagProvider>(
        builder: (context, tagProvider, child) {
          return Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/tag.webp"),
                    fit: BoxFit.cover,
                    opacity: 0.15,
                  ),
                ),
              ),
              FutureBuilder<List<Tag>>(
                future: futureTag,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
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
                                  builder: (context) =>
                                      TagDetail(tag: snapshot.data![index]),
                                ),
                              );
                            },
                            leading:
                                Icon(Icons.label, color: Color(0xFF344E41)),
                            title: Text(
                              snapshot.data![index].name,
                              style: TextStyle(
                                fontFamily: 'Taviraj',
                                fontWeight: FontWeight.bold,
                                color: Colors.green[800],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Center(child: Text("No tags found"));
                  }
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TagCreate(),
                  ),
                );
              },
              child: Icon(Icons.add, color: Color(0XFFFED16A)),
              backgroundColor: Color(0XFF987D3F),
            ),
          ),
        ],
      ),
    );
  }
}
