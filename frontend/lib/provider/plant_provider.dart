import 'package:flutter/widgets.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> plants = [];
  Plant? prevPlant;

  Future<List<Plant>> fetchPlants(var gardenId) async {
    try {
      plants = await fetchPlantsApi(gardenId);
      notifyListeners();
      return plants;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createPlant(Map<String, dynamic> plant, var gardenId) async {
    createPlantApi(plant, gardenId);
    notifyListeners();
  }


  Future<void> updatePlant(Map<String, dynamic> plant) async {
    updatePlantApi(plant);
    notifyListeners();
  }

  Future<void> deletePlant(var plantId) async {
    deletePlantApi(plantId);
    notifyListeners();
  }
}
