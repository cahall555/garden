import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import 'plant_detail.dart';

class GardenDetail extends StatelessWidget {
  final Garden garden;

  GardenDetail({Key? key, required this.garden}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(garden.name),
      ),
      body: SingleChildScrollView( // Added SingleChildScrollView to handle possible overflow
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: ListTile(
                title: Text('Zone: ' + garden.zone),
              ),
            ),
            FutureBuilder<List<Plant>>(
              future: fetchPlants(garden.id), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    shrinkWrap: true, 
                    physics: NeverScrollableScrollPhysics(), 
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
        				builder: (context) => PlantDetail(plant: snapshot.data![index]),
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
                          trailing: Icon(Icons.favorite),
                        ),
                      );
                    },
                  );
                } else {
                  return Text("No plants found");
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('Add Plant'),
        ),
	      ),
    );
  }
}

