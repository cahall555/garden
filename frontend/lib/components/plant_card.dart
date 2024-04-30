import 'package:flutter/material.dart';
import '../model/plant.dart';
import '../view/plant_detail.dart';

class PlantCard extends StatelessWidget {
  final String title;
  final bool germinated;
  final int days_to_harvest;
  final Plant plant;
//  final String imageUrl;

  PlantCard({
    required this.title,
    required this.germinated,
    required this.days_to_harvest,
    required this.plant,
//    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 12,
        shadowColor: Colors.pink[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        color: Color(0XFF588157),
        margin: EdgeInsets.all(12),
        child: ListTile(
          contentPadding: EdgeInsets.all(10),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PlantDetail(plant: plant),
              ),
            );
            print('changing to plant detail');
          },
          //    leading: Icon(Icons.local_florist),
          title: Text(
            title,
	    textAlign: TextAlign.center,
	    textScaleFactor: 1.5,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[50],
            ),
          ),
          subtitle: Text('Days to Harvest: ' + days_to_harvest.toString() + '\n' + (germinated ? 'Plant has germinated' : 'Plant has not germinated'),
              textAlign: TextAlign.center,
		  style: TextStyle(
                color: Colors.blueGrey[50],
              )),
          //  trailing: Icon(Icons.favorite),
        ),
      ),
    );
  }
}
