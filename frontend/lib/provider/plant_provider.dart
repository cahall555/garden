import 'package:flutter/widgets.dart';
import '../model/plant.dart';
import '../model/sync_log.dart';
import '../model/apis/plant_api.dart';
import 'package:frontend/services/repositories/plant_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class PlantProvider with ChangeNotifier {
  List<Plant> plants = [];
  Plant? prevPlant;
  final plantApiService;
  final SyncLogRepository syncLogRepository;
  final PlantRepository plantRepository;

  PlantProvider(
      this.plantApiService, this.plantRepository, this.syncLogRepository);

  Future<List<Plant>> fetchPlants(var gardenId) async {
    try {
      await syncWithBackend(gardenId);
      plants = await plantRepository.fetchCurrentPlants(gardenId);
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

  Future<void> createPlant(Map<String, dynamic> plant) async {
    try {
      final newPlant = Plant.fromJson(plant);
      await plantRepository.insertPlant(newPlant);
      await syncWithBackend(newPlant.garden_id);
    } catch (e) {
      print('error creating plant: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updatePlant(Map<String, dynamic> plant) async {
    try {
      final updatePlant = Plant.fromJson(plant);
      await plantRepository.updatePlant(updatePlant);
      await syncWithBackend(updatePlant.garden_id);
    } catch (e) {
      print('error updating plant: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deletePlant(Plant plant) async {
    try {
      print("isOnline when delete is triggered: ${await isOnline()}");
      if (await isOnline()) {
        await plantApiService.deletePlantApi(plant.id);
        print("Plant deleted from backend: ${plant.id}");
        await plantRepository.deletePlant(plant.id);
      } else {
        print("Offline: Marking plant for deletion locally");
        await plantRepository.markForDeletion(plant.id);
      }

      await syncWithBackend(plant.garden_id);
    } catch (e) {
      print("Error deleting plant: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> syncWithBackend(var gardenId) async {
    if (await isOnline()) {
      try {
        print("Syncing plants for gardentId: $gardenId");

        final syncLog = await syncLogRepository.getSyncLog('plants');
        final lastSyncTime = syncLog?.lastSyncTime;
        final plantsFromBackend =
            await plantApiService.fetchPlantsApi(gardenId);
        final plantsFromLocal = await plantRepository.fetchAllPlants(gardenId);
        final backendPlantMap = {
          for (var plant in plantsFromBackend) plant.id: plant
        };
        final localPlantMap = {
          for (var plant in plantsFromLocal) plant.id: plant
        };

        for (var plantId in localPlantMap.keys) {
          final localPlant = localPlantMap[plantId];
          print("Local plant marked for deletion: ${localPlant?.toJson()}");
          if (localPlant!.marked_for_deletion == 1) {
            try {
              await plantApiService.deletePlantApi(plantId);
              print("Plant deleted from backend: $plantId");
              await plantRepository.deletePlant(plantId);
            } catch (e) {
              print("Error deleting plant: $e");
            }
          } else if (!backendPlantMap.containsKey(plantId)) {
            print("Plant not found in backend: ${localPlant?.toJson()}");
            await plantApiService.createPlantApi(
                localPlant!.toJson(), gardenId);
          } else if (localPlant.updatedAt
              .isAfter(backendPlantMap[plantId]!.updatedAt)) {
            await plantApiService.updatePlantApi(localPlant!.toJson());
          }
        }

        for (var plantId in backendPlantMap.keys) {
          final backendPlant = backendPlantMap[plantId];
          if (!localPlantMap.containsKey(plantId)) {
            await plantRepository.insertPlant(backendPlant!);
          } else if (backendPlant.updatedAt
              .isAfter(localPlantMap[plantId]!.updatedAt)) {
            await plantRepository.updatePlant(backendPlant!);
          }
        }

        plants = await plantRepository.fetchAllPlants(gardenId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'plants',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Sync completed successfully for gardenId: $gardenId',
        ));
        notifyListeners();
        print("Sync completed successfully for gardenId: $gardenId");
      } catch (e) {
        print('Error syncing with backend: $e');
      }
    } else {
      print('Offline: Sync skipped');
    }
  }

  Future<bool> isOnline() async {
    return await connectionStatus.checkConnection();
  }
}
