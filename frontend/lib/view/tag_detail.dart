import 'package:flutter/material.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import '../provider/tag_provider.dart';
import '../provider/plants_tag_provider.dart';
import '../provider/plant_provider.dart';
import 'tag_update.dart';
import 'package:provider/provider.dart';

class TagDetail extends StatelessWidget {
  final Tag tag;

  TagDetail({Key? key, required this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
//    var relatedPlants = tag.RelatedPlants ??
//        [];

    return Scaffold(
      appBar: AppBar(
        title: Text(tag.name, style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/tag.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
      ),
//      body: relatedPlants.isEmpty
//          ? Center(child: Text("No related plants found"))
//          : ListView.builder(
//              itemCount: relatedPlants.length,
//              itemBuilder: (context, index) {
//                var plant = relatedPlants[index];
//                return Card(
//                  elevation: 5,
//                  margin: EdgeInsets.all(8),
//                  child: ListTile(
//                    onTap: () {
      // Navigator logic here if needed, for example to plant details
//                    },
//                    leading: Icon(Icons.local_florist),
//                    title: Text(
//                      plant.name,
//                      style: TextStyle(
//                        fontWeight: FontWeight.bold,
//                        color: Colors.green[800],
//                      ),
//                    ),
//                    trailing: Icon(Icons.favorite),
//                  ),
//                );
//              },
//            ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TagUpdate(tag: tag),
                  ),
                );
              },
              child: Icon(Icons.edit, color: Color(0XFFFED16A)),
              backgroundColor: Color(0XFF987D3F),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: FloatingActionButton(
              onPressed: () {
                Provider.of<TagProvider>(context, listen: false)
                    .deleteTag(tag.id);
                Navigator.of(context).pop();
              },
              child: Icon(Icons.delete, color: Color(0XFF987D3F)),
              backgroundColor: Color(0XFFFED16A),
            ),
          ),
        ],
      ),
    );
  }
}
