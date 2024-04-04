import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';
import '../provider/garden_provider.dart';
import 'garden_detail.dart';
import 'garden_create.dart';

class GardenList extends StatefulWidget {
  @override
  _GardenListState createState() => _GardenListState();
}

class _GardenListState extends State<GardenList> {
  Future<List<Garden>>? futureGardens;

   @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (futureGardens == null) {
      final gardenProvider = Provider.of<GardenProvider>(context, listen: false);
      futureGardens = gardenProvider.fetchGarden();
    }
  }

  @override
  Widget build(BuildContext context) {

  return Consumer<GardenProvider>(
    builder: (context, gardenProvider, child) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<List<Garden>>(
            future: futureGardens,
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
                              builder: (context) => GardenDetail(garden: snapshot.data![index]),
                            ),
                          );
                        },
                        leading: Icon(Icons.local_florist),
                        title: Text(
                          snapshot.data![index].name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        ),
                        subtitle: Text(snapshot.data![index].zone),
                        trailing: Icon(Icons.favorite),
                      ),
                    );
                  },
                );
              } else {
                return Text("No gardens found");
              }
            },
          ),
          Positioned(
            bottom: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GardenCreate()));
              },
              child: Text('Add Garden'),
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              ),
            ),
          ),
        ],
	),
      );
      },
    );
  }
}

