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
import 'package:intl/intl.dart';
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

  String formatDate(DateTime? date) {
    if (date == null) {
      return 'date not set';
    }
    if (DateFormat('y').format(date.toLocal()) == '0') {
      return 'date not set';
    }
    final formatter = DateFormat('yMMMMd');
    return formatter.format(date.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final journalProvider =
        Provider.of<JournalProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(plant.name, style: TextStyle(fontFamily: 'Taviraj')),
      ),
      body: Container(
        width: screenSize.width,
        height: screenSize.height,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/herb_garden.webp"),
            fit: BoxFit.cover,
            opacity: 0.15,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                color: Colors.transparent,
                elevation: 12,
                margin: EdgeInsets.all(8),
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
                    title: Text(
                        plant.germinated
                            ? "plant has germinated"
                            : "Plant is not germinated",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Taviraj',
                          color: Colors.white,
                        )),
                    subtitle:
                        Text("Date Planted: ${formatDate(plant.date_planted)}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Taviraj',
                              color: Colors.white,
                            )),
                  ),
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
                                color: Colors.transparent,
                                elevation: 12,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 20),
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
                                    borderRadius: BorderRadius.circular(25.0),
                                  ),
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
                                      leading: Icon(Icons.library_books_rounded,
                                          color: Color(0XFF987D3F)),
                                      title: Text(
                                        snapshot.data![index].title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Taviraj',
                                          color: Colors.white,
                                        ),
                                      ),
                                      subtitle:
                                          Text(snapshot.data![index].entry,
                                              style: TextStyle(
                                                fontFamily: 'Taviraj',
                                                color: Colors.white,
                                              )),
                                    ),
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
                            activeDotColor: Color(0xFF344E41),
                            dotColor: Color(0xFFFED16A),
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
                          color: Colors.transparent,
                          elevation: 12,
                          margin: EdgeInsets.all(8),
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
                              borderRadius: BorderRadius.circular(25.0),
                            ),
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
                              leading: Icon(Icons.water_drop_rounded,
                                  color: Color(0XFF987D3F)),
                              title: Text(
                                snapshot.data![index].notes,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Taviraj',
                                  color: Colors.white,
                                ),
                              ),
                            ),
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
                            fontFamily: 'Taviraj',
                            color: Colors.white,
                          ),
                        );
                        var textPainter = TextPainter(
                          text:
                              TextSpan(text: tag.name, style: textWidget.style),
                          maxLines: 1,
                          //textDirection: TextDirection.ltr,
                        );
                        textPainter.layout();

                        var textWidth = textPainter.width + 10;
                        var screenWidth = MediaQuery.of(context).size.width;

                        return Card(
                          color: Colors.transparent,
                          elevation: 12,
                          margin: EdgeInsets.all(8),
                          child: Container(
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
                                borderRadius: BorderRadius.circular(25.0),
                              ),
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
                                leading: Icon(Icons.label_rounded,
                                    color: Color(0XFF987D3F)),
                                title: textWidget,
                              ),
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
