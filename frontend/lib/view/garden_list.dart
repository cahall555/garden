import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/garden_bottom_nav.dart';
import '../components/garden_card.dart';
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
      final gardenProvider =
          Provider.of<GardenProvider>(context, listen: false);
      futureGardens = gardenProvider.fetchGarden();
    }
  }

  final GardenCard gardenCard = GardenCard(
    title: 'Herb Garden',
    zone: '7',
    description: 'This is a description of the garden',
    garden: Garden(
      id: '1',
      name: 'Herb Garden',
      zone: '7',
      plants: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<GardenProvider>(
      builder: (context, gardenProvider, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Gardens'),
          ),
          body: Stack(
            children: <Widget>[
              Image.asset(
                'assets/' + ('herb_garden.webp'),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
              ),
              FutureBuilder<List<Garden>>(
                future: futureGardens,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        Garden garden = snapshot.data![index];
                        String plantCount =
                            'Put Plant count here'; //snapshot.data![index].plants.length.toString() ?? '0';
                        String gardenName = snapshot.data![index].name;
                        String gardenZone = snapshot.data![index].zone;
                        return GardenCard(
                            title: gardenName,
                            zone: gardenZone,
                            description: plantCount,
                            garden: garden); //Card(
                      },
                    );
                  } else {
                    return Text("No gardens found");
                  }
                },
              ),
            ],
          ),
//	  bottomNavigationBar: BottomNavigation(),
        );
      },
    );
  }
}
