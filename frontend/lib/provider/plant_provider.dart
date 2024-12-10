import 'package:flutter/widgets.dart';
import '../model/plant.dart';
import '../model/apis/plant_api.dart';
import 'package:frontend/services/repositories/plant_repository.dart';
import 'package:frontend/services/connection_status.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> plants = [];
  Plant? prevPlant;
  final plantApiService;
  final PlantRepository plantRepository;

  PlantProvider(this.plantApiService, this.plantRepository);

  Future<List<Plant>> fetchPlants(var gardenId) async {
    try {
      plants = await plantRepository.fetchAllPlants(gardenId);
      if (plants.isEmpty) {
        plants = await plantApiService.fetchPlantsApi(gardenId);
        for (var plant in plants) {
          plantRepository.insertPlant(plant);
        }
      }
      notifyListeners();
      return plants;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createPlant(Map<String, dynamic> plant, var gardenId) async {
    try {
      await plantApiService.createPlantApi(plant, gardenId);
      final newPlant = Plant.fromJson(plant);
      await plantRepository.insertPlant(newPlant);
    } catch (e) {
      print('error creating plant: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updatePlant(Map<String, dynamic> plant) async {
    plantApiService.updatePlantApi(plant);
    notifyListeners();
  }

  Future<void> deletePlant(var plantId) async {
    plantApiService.deletePlantApi(plantId);
    plantRepository.deletePlant(plantId);
    notifyListeners();
  }

  Future<void> syncWithBackend(var gardenId) async {
    if (await isOnline()) {
      try {
        final plantsFromBackend =
            await plantApiService.fetchPlantsApi(gardenId);
        for (var plant in plantsFromBackend) {
          await plantRepository.insertPlant(plant);
        }
        plants = await plantRepository.fetchAllPlants(gardenId);
        notifyListeners();
      } catch (e) {
        print('Error syncing with backend: $e');
      }
    } else {
      print('Offline: Sync skipped');
    }
  }

  Future<bool> isOnline() async {
 //	return await ConnectionStatusSingleton.getInstance().checkConnection();
	  return true;
  }
}
