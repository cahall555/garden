import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';
import 'garden_detail.dart';

class GardenList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Garden>>(
              future: fetchGarden(),
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
                        	title: Text(snapshot.data![index].name,
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
     
      );
  }
}

