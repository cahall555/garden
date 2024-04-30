import 'package:flutter/material.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';
import '../model/apis/custom_exception.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
//import '../components/journal_widget.dart';
import 'plant_update.dart';
import 'ws_create.dart';
import 'ws_update.dart';
import 'journal_detail.dart';
import 'journal_create.dart';
import 'tag_create.dart';
import 'tag_detail.dart';
import '../provider/plant_provider.dart';
import '../provider/ws_provider.dart';
import '../provider/tag_provider.dart';
import '../provider/plants_tag_provider.dart';
import '../provider/journal_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PlantDetail extends StatelessWidget {
  final Plant plant;

  PlantDetail({Key? key, required this.plant}) : super(key: key);

  Future<List<Tag>> fetchDataTags(BuildContext context) async {
    final tagProvider = Provider.of<TagProvider>(context, listen: false);
    final plantsTagProvider =
        Provider.of<PlantsTagProvider>(context, listen: false);
    final plantTags = await plantsTagProvider.fetchPlantsTag(plant.id);
    List<Tag> tags = [];
    for (var pt in plantTags) {
      print(pt.tag_id);
      final tag = await tagProvider.fetchTag(pt.tag_id);

      tags.addAll(tag);
    }
    return tags;
  }

  @override
  Widget build(BuildContext context) {
 final Size screenSize = MediaQuery.of(context).size;

    final journalProvider =
        Provider.of<JournalProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/herb_garden.webp"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 5,
                margin: EdgeInsets.all(8),
                child: ListTile(
                  title: Text(plant.germinated
                      ? "plant has germinated"
                      : "Plant is not germinated"),
                ),
              ),
              FutureBuilder<List<Journal>>(
                future: journalProvider.fetchPlantJournal(plant.id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    PageController pageController =
                        PageController(viewportFraction: 0.85);

                    return Column(
                      children: [
                        SizedBox(
                          height: 220,
                          child: PageView.builder(
                            controller: pageController,
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Card(
                                elevation: 12,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
                                color: Colors.green[100],
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JournalDetail(
                                            journal: snapshot.data![index],
                                          ),
                                        ),
                                      );
                                    },
                                    leading: Icon(Icons.library_books_rounded),
                                    title: Text(
                                      snapshot.data![index].title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green[800],
                                      ),
                                    ),
                                    subtitle: Text(snapshot.data![index].entry),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SmoothPageIndicator(
                          controller: pageController,
                          count: snapshot.data!.length,
                          effect: WormEffect(
                            dotWidth: 10.0,
                            dotHeight: 10.0,
                            activeDotColor: Colors.green,
                            dotColor: Colors.red,
                          ),
                        ),
                      ],
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
                    if (snapshot.error is CustomHttpException &&
                        (snapshot.error as CustomHttpException).message ==
                            '404 Not Found') {
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WsUpdate(
                                      plant: this.plant,
                                      ws: snapshot.data![index]),
                                ),
                              );
                            },
                            leading: Icon(Icons.water_drop_rounded),
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
              FutureBuilder<List<Tag>>(
                future: fetchDataTags(context),
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
                        var tag = snapshot.data![index];
                        var textWidget = Text(
                          tag.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green[800],
                          ),
                        );
                        var textPainter = TextPainter(
                          text:
                              TextSpan(text: tag.name, style: textWidget.style),
                          maxLines: 1,
                          textDirection: TextDirection.ltr,
                        );
                        textPainter.layout();

                        var textWidth = textPainter.width + 10;
                        var screenWidth = MediaQuery.of(context).size.width;

                        return Card(
                          elevation: 12,
                          margin: EdgeInsets.all(8),
                          child: Container(
                            width: textWidth > screenWidth
                                ? screenWidth
                                : textWidth,
                            child: ListTile(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TagDetail(tag: tag),
                                  ),
                                );
                              },
                              leading: Icon(Icons.label_rounded),
                              title: textWidget,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("No Tags found");
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlantUpdate(plant: plant)),
                    );
                    // Navigator.of(context).pop();
                  },
                  child: Text('Update Plant'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    List<WaterSchedule> schedules =
                        await fetchWaterSchedule(plant.id);

                    if (schedules.isNotEmpty) {
                      WaterSchedule ws = schedules.first;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                WsUpdate(plant: this.plant, ws: ws)),
                      );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WsCreate(plant: this.plant)),
                      );
                    }
                  },
                  child: Text('Water Schedule'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Provider.of<PlantProvider>(context, listen: false)
                        .deletePlant(plant.id);
                    Navigator.of(context).pop();
                  },
                  child: Text('Delete Plant'),
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
                              JournalCreate(plant: this.plant)),
                    );
                    // Navigator.of(context).pop();
                  },
                  child: Text('Add Journal'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TagCreate(plant: this.plant)),
                    );
                    // Navigator.of(context).pop();
                  },
                  child: Text('Add Tag'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
