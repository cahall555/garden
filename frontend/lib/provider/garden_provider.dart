import 'package:flutter/widgets.dart';
import '../model/garden.dart';
import '../model/apis/garden_api.dart';

class GardenProvider with ChangeNotifier {
  List<Garden> gardens = [];
  Garden? prevGarden;
  final gardenApiService;
  GardenProvider(this.gardenApiService);

  Future<List<Garden>> fetchGarden(var accountId) async {
    try {
      gardens = await gardenApiService.fetchGardenApi(accountId);
      notifyListeners();
      return gardens;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createGarden(Map<String, dynamic> garden) async {
    gardenApiService.createGardenApi(garden);
    notifyListeners();
  }

  Future<void> updateGarden(Map<String, dynamic> garden, var gardenId) async {
    gardenApiService.updateGardenApi(garden, gardenId);

    notifyListeners();
    if (prevGarden != null) {
      int index = gardens.indexWhere((g) => g.id == prevGarden!.id);

      if (index != -1) {
        gardens[index] = Garden.fromJson(garden);
      }
    }
  }

  Future<void> deleteGarden(var gardenId) async {
    gardenApiService.deleteGardenApi(gardenId);
    notifyListeners();
  }
}
