import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'auth_landing.dart';
import 'tags_list.dart';
import '../components/garden_card.dart';
import '../model/garden.dart';
import '../model/account.dart';
import '../model/users_account.dart';
import '../model/apis/users_account_api.dart';
import '../provider/users_account_provider.dart';
import '../model/apis/garden_api.dart';
import '../provider/auth_provider.dart';
import '../provider/garden_provider.dart';
import 'garden_detail.dart';
import 'garden_create.dart';

class GardenList extends StatefulWidget {
  final UserAccounts userAccounts;
  const GardenList({Key? key, required this.userAccounts}) : super(key: key);
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
      futureGardens =
          gardenProvider.fetchGarden(widget.userAccounts.account_id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<GardenProvider>(
      builder: (context, gardenProvider, child) {
        return Scaffold(
          //appBar: AppBar(
          //title: Text('Gardens', style: TextStyle(fontFamily: 'Taviraj')),
          //),
          body: Stack(
            children: <Widget>[
              Image.asset(
                'assets/' + ('garden.webp'),
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
                        String gardenDescription =
                            snapshot.data![index].description;
                        return GardenCard(
                            title: gardenName,
                            description: gardenDescription,
                            //description: plantCount,
                            garden: garden,
                            userAccounts: widget.userAccounts);
                      },
                    );
                  } else {
                    return Text("No gardens found");
                  }
                },
              ),
            ],
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
                          builder: (context) =>
                              GardenCreate(userAccounts: widget.userAccounts)),
                    );
                  },
                  child: Icon(Icons.add, color: Color(0XFFFED16A)),
                  backgroundColor: Color(0XFF987D3F),
                  tooltip: 'Add Garden',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            TagList(userAccounts: widget.userAccounts),
                      ),
                    );
                  },
                  child: Icon(Icons.label, color: Color(0XFF987D3F)),
                  backgroundColor: Color(0XFFFED16A),
                  tooltip: 'Tags',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: FloatingActionButton(
                  onPressed: () {
                    Provider.of<AuthProvider>(context, listen: false).logout();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => LandingPage(),
                      ),
                    );
                  },
                  child: Icon(Icons.logout, color: Color(0XFF987D3F)),
                  backgroundColor: Color(0XFFFED16A),
                  tooltip: 'Logout',
                ),
              ),
            ],
          ),

          //bottomNavigationBar: BottomNavigation(),
        );
      },
    );
  }
}
