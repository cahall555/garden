import 'package:flutter/material.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';
import '../model/plant.dart';
import '../model/users_account.dart';
import '../model/apis/plant_api.dart';
//import '../components/garden_detail_nav.dart';
import '../components/plant_card.dart';
import 'plant_detail.dart';
import 'plant_create.dart';
import 'garden_update.dart';
import '../provider/garden_provider.dart';
import '../provider/plant_provider.dart';
import 'package:provider/provider.dart';

class GardenDetail extends StatelessWidget {
  final Garden garden;
  final UserAccounts userAccounts;

  GardenDetail({Key? key, required this.garden, required this.userAccounts})
      : super(key: key);

  final PlantCard plantCard = PlantCard(
    title: 'Tomato',
    germinated: true,
    days_to_harvest: 60,
    plant: Plant(
      id: '1',
      name: 'Tomato',
      germinated: true,
      days_to_harvest: 60,
      plant_count: 1,
      date_planted: DateTime.parse('2022-01-01'),
      date_germinated: DateTime.parse('2022-01-15'),
      garden_id: '1',
      account_id: '1',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  );
  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      //  bottomNavigationBar: GardenDetailNavigation(garden: garden),
      appBar: AppBar(
        title: Text(garden.name, style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/garden.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50.0),
                ),
                margin: EdgeInsets.all(8),
                child: Container(
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFFFED16A),
                          Color(0xFF987D3F),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: ListTile(
                      title: Text('Description: ' + garden.description,
                          style: TextStyle(
                              fontFamily: 'Taviraj',
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
              FutureBuilder<List<Plant>>(
                future: Provider.of<PlantProvider>(context, listen: false)
                    .fetchPlants(garden.id),
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
                        return PlantCard(
                          title: snapshot.data![index].name,
                          germinated: snapshot.data![index].germinated,
                          days_to_harvest:
                              snapshot.data![index].days_to_harvest,
                          plant: snapshot.data![index],
                        );
                      },
                    );
                  } else {
                    return Text("No plants found");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to update garden page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GardenUpdate(
                              garden: this.garden,
                              userAccounts: this.userAccounts)),
                    );
                  },
                  child: Text('Update Garden'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<GardenProvider>(context, listen: false)
                        .deleteGarden(garden.id);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete Garden'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              PlantCreate(garden: this.garden)),
                    );
                  },
                  child: Text('Add Plant'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
