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
                  builder: (context) => PlantDetail(plant: plant),
                ),
              );
              print('changing to plant detail');
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
            subtitle: Text(
                'Days to Harvest: ' +
                    days_to_harvest.toString() +
                    '\n' +
                    (germinated
                        ? 'Plant has germinated'
                        : 'Plant has not germinated') + '\n' + 'Plant Count: ' + plant.plant_count.toString() + '\n' + 'Date Planted: ' + plant.date_planted.toString(),
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
