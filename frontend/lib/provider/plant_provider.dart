import 'package:flutter/widgets.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> plants = [];
  Plant? prevPlant;
  final plantApiService;
  PlantProvider(this.plantApiService);

  Future<List<Plant>> fetchPlants(var gardenId) async {
    try {
      plants = await plantApiService.fetchPlantsApi(gardenId);
      notifyListeners();
      return plants;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createPlant(Map<String, dynamic> plant, var gardenId) async {
    plantApiService.createPlantApi(plant, gardenId);
    notifyListeners();
  }


  Future<void> updatePlant(Map<String, dynamic> plant) async {
    plantApiService.updatePlantApi(plant);
    notifyListeners();
  }

  Future<void> deletePlant(var plantId) async {
    plantApiService.deletePlantApi(plantId);
    notifyListeners();
  }
}
