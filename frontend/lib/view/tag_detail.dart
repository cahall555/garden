import 'package:flutter/material.dart';
import '../model/plant.dart';
import '../model/tag.dart';
import '../model/plants_tag.dart';
import '../provider/tag_provider.dart';
import '../provider/plants_tag_provider.dart';
import '../provider/plant_provider.dart';
import 'plant_detail.dart';
import 'tag_update.dart';
import 'package:provider/provider.dart';

class TagDetail extends StatefulWidget {
  final Tag tag;

  TagDetail({Key? key, required this.tag}) : super(key: key);

  @override
  _TagDetailState createState() => _TagDetailState();
}

class _TagDetailState extends State<TagDetail> {
  late Future<List<Plant?>> relatedPlantsFuture;

  @override
  void initState() {
    super.initState();
    relatedPlantsFuture = fetchRelatedPlants();
  }

  Future<List<Plant?>> fetchRelatedPlants() async {
    final plantsTagProvider =
        Provider.of<PlantsTagProvider>(context, listen: false);
    final plantProvider =
        Provider.of<PlantProvider>(context, listen: false);

    try {
      List<PlantTags> plantTags =
          await plantsTagProvider.fetchRelatedPlants(widget.tag.id);

      List<Plant?> relatedPlants = [];

      for (var plantTag in plantTags) {
        Plant? plant = await plantProvider.fetchPlant(plantTag.plant_id);
        if (plant != null) {
          relatedPlants.add(plant);
        }
      }

      return relatedPlants;
    } catch (e) {
      return Future.error("Failed to fetch related plants");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.tag.name, style: const TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/tag.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: FutureBuilder<List<Plant?>>(
          future: relatedPlantsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No plants found in this garden."));
            }

            List<Plant?> relatedPlants = snapshot.data!;

            return ListView.builder(
              itemCount: relatedPlants.length,
              itemBuilder: (context, index) {
                var plant = relatedPlants[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlantDetail(plant: plant!),
                        ),
                      );
                    },
                    title: Text(
                      plant?.name ?? "Plant Name",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[800],
                      ),
                    ),
                    subtitle: Text("Plant Count: ${plant?.plant_count}" ?? "Plant Count: 0"),
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TagUpdate(tag: widget.tag),
                  ),
                );
              },
              child: const Icon(Icons.edit, color: Color(0XFFFED16A)),
              backgroundColor: const Color(0XFF987D3F),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                Provider.of<TagProvider>(context, listen: false)
                    .deleteTag(widget.tag.toJson());
                Provider.of<PlantsTagProvider>(context, listen: false)
                    .deletePlantTagTagId(widget.tag.id);
                Navigator.of(context).pop();
              },
              child: const Icon(Icons.delete, color: Color(0XFF987D3F)),
              backgroundColor: const Color(0XFFFED16A),
            ),
          ),
        ],
      ),
    );
  }
}

