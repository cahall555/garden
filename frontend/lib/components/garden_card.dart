import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../view/garden_detail.dart';

class GardenCard extends StatelessWidget {
  final String title;
  final String zone;
  final String description;
  final Garden garden;
//  final String imageUrl;

  GardenCard({
    required this.title,
    required this.zone,
    required this.description,
    required this.garden,
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
                builder: (context) => GardenDetail(garden: garden),
              ),
            );
            print('changing to garden detail');
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
          subtitle: Text('Garden Zone: ' + zone + '\n' + description,
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
