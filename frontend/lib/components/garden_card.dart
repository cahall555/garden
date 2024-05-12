import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../view/garden_detail.dart';

class GardenCard extends StatelessWidget {
  final String title;
  final String description;
  final Garden garden;
//  final String imageUrl;

  GardenCard({
    required this.title,
    required this.description,
    required this.garden,
//    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 12,
        shadowColor: Color(0XFF2A203D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        margin: EdgeInsets.all(12),
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF344E41),
                Color(0xFFFED16A),
              ],
            ),
            borderRadius: BorderRadius.circular(50.0),
          ),
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
            title: Text(
              title,
              textAlign: TextAlign.center,
              textScaleFactor: 1.5,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Taviraj',
                color: Colors.white,
              ),
            ),
            subtitle: Text('Garden Description: ' + description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Taviraj',
                  color: Colors.white,
                )),
          ),
        ),
      ),
    );
  }
}
