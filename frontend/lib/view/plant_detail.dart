import 'package:flutter/material.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';
import '../model/apis/custom_exception.dart';

class PlantDetail extends StatelessWidget {
  final Plant plant;

  PlantDetail({Key? key, required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              elevation: 5,
              margin: EdgeInsets.all(8),
              child: ListTile(
	     	 title: Text(plant.germinated ? "plant has germinated" : "Plant is not germinated"),
	     ),
            ),
           FutureBuilder<List<Journal>>(
	      future: fetchPlantJournal(plant.id), 
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
                           
                          },
                          leading: Icon(Icons.local_florist),
                          title: Text(
                            snapshot.data![index].title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green[800],
                            ),
                          ),
			  subtitle: Text( snapshot.data![index].entry),
                          trailing: Icon(Icons.favorite),
                        ),
                      );
                    },
                  );
                } else {
                  return Text("No journals found");
                }
              },
            ),
	FutureBuilder<List<WaterSchedule>>(
	      future: fetchWaterSchedule(plant.id), 
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
			if (snapshot.error is CustomHttpException && (snapshot.error as CustomHttpException).message == '404 Not Found') {
        			return Text("No Water Schedules found for this plant");
			} else {
                  		return Text("Error: ${snapshot.error}");
			}
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
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
                           
                          },
                          leading: Icon(Icons.local_florist),
                          title: Text(
                            snapshot.data![index].notes,
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
                  return Text("No Water Schedules found");
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
          child: Text('Update Plant'),
        ),
	      ),
    );
  }
}

