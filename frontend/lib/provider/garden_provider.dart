import 'package:flutter/widgets.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';

class GardenProvider with ChangeNotifier {
  List<Garden> gardens = [];
  //Garden garden;
  Garden? prevGarden;

  //GardenProvider({this.gardens, this.garden});

  //getGardens() => this.gardens;
  //setGardens(List<Garden> gardens) => this.gardens = gardens;

  //getGarden() => this.garden;
  //setGarden(Garden garden) => this.garden = garden;

  Future<List<Garden>> fetchGarden() async {
    try {
    	gardens = await fetchGardenApi();
    	notifyListeners();
	return gardens;
    } catch (e) {
    	print(e);
	return[];
    }
  }

  //Future<void> fetchGarden({Garden garden}) async {
   // this.garden = await fetchGarden(garden?.id);
   // this.prevGarden = garden;
   // notifyListeners();
 // }

  Future<void> createGarden(Map<String, dynamic> garden) async {
    createGardenApi(garden);
    notifyListeners();
  }

  Future<void> updateGarden(Map<String, dynamic> garden, var gardenId) async {
    updateGardenApi(garden, gardenId);

       notifyListeners();
    if (prevGarden != null) {
    	int index = gardens.indexWhere((g) => g.id == prevGarden!.id);
    
    	if (index != -1) {
      		gardens[index] = Garden.fromJson(garden);
    	}
    }
}

 // Future<void> deleteGarden(Garden garden) async {
  //  await deleteGardenApi(garden.id);
  //  gardens.removeAt(this.gardens.indexOf(garden));
  //  notifyListeners();
 // }
}
