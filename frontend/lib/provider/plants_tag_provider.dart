import 'package:flutter/widgets.dart';
import '../model/plants_tag.dart';
import '../model/sync_log.dart';
import '../model/apis/plants_tag_api.dart';
import 'package:frontend/services/repositories/plants_tag_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class PlantsTagProvider with ChangeNotifier {
  List<PlantTags> pt = [];
  //Tag? prevTag;
  final plantsTagApiService;
  final PlantsTagRepository plantsTagRepository;
  final SyncLogRepository syncLogRepository;
  PlantsTagProvider(this.plantsTagApiService, this.plantsTagRepository,
      this.syncLogRepository);

  Future<List<PlantTags>> fetchPlantsTag(var plantId) async {
    try {
      await syncWithBackend(plantId);
      pt = await plantsTagRepository.fetchCurrentPlantTags(plantId);
      if (pt.isEmpty) {
        pt = await plantsTagApiService.fetchPlantsTagApi(plantId);
        for (var plantTag in pt) {
          plantsTagRepository.insertPlantsTag(plantTag);
        }
      }
      notifyListeners();
      return pt;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<PlantTags>> fetchPlantsTagAccount(var accountId) async {
    try {
      pt = await plantsTagRepository.fetchCurrentPlantTagsAccount(accountId);
      if (pt.isEmpty) {
	pt = await plantsTagApiService.fetchPlantsTagAccountApi(accountId);
	for (var plantTag in pt) {
	  plantsTagRepository.insertPlantsTag(plantTag);
	}
      }
      notifyListeners();
      return pt;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<PlantTags>> fetchRelatedPlants(var tagId) async {
    try {
      pt = await plantsTagRepository.fetchRelatedPlants(tagId);
      if (pt.isEmpty) {
	pt = await plantsTagApiService.fetchRelatedPlantsApi(tagId);
	for (var plantTag in pt) {
	  plantsTagRepository.insertPlantsTag(plantTag);
	}
      }
      notifyListeners();
      return pt;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<void> createPlantsTag(Map<String, dynamic> plantTag) async {
    try {
      if (plantTag.isNotEmpty) {
        final newPlantTag = PlantTags.fromJson(plantTag);
        await plantsTagRepository.insertPlantsTag(newPlantTag);
        await syncWithBackend(plantTag['plant_id']);
      }
    } catch (e) {
      throw Exception('Failed to create plant tag: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deletePlantTag(var id) async {
    try {
      await plantsTagRepository.deletePlantTag(id);
      notifyListeners();
    } catch (e) {
      print('Error deleting plant tag: $e');
    }
  }

  Future<void> deletePlantTagTagId(var tagId) async {
    try {
      await plantsTagRepository.deletePlantTagTagId(tagId);
      notifyListeners();
    } catch (e) {
      print('Error deleting plant tag: $e');
    }
  }

  Future<void> syncWithBackend(var plantId) async {
    if (await isOnline()) {
      try {
        print("Syncing plant tags for plantId: $plantId");

        final syncLog = await syncLogRepository.getSyncLog('plant_tags');
        final lastSyncTime = syncLog?.lastSyncTime;
	
	print("starting backend sync for plants tag with plantId: $plantId");
        final plantTagsFromBackend =
            await plantsTagApiService.fetchPlantsTagApi(plantId);

	print("starting local sync for plants tag with plantId: $plantId");
        final plantTagsFromLocal =
            await plantsTagRepository.fetchAllPlantTags(plantId);

        final backendPlantsTagMap = {
          for (var plantsTag in plantTagsFromBackend) plantsTag.id: plantsTag
        };
        final localPlantsTagMap = {
          for (var plantsTag in plantTagsFromLocal) plantsTag.id: plantsTag
        };

	print("backendPlantsTagMap: $backendPlantsTagMap");
        for (var plantsTagId in localPlantsTagMap.keys) {
          final localPlantsTag = localPlantsTagMap[plantsTagId];
          print(
              "Local plant tag marked for deletion: ${localPlantsTag?.toJson()}");
          if (localPlantsTag!.marked_for_deletion == 1) {
            try {
              await plantsTagApiService.deletePlantsTagApi(plantsTagId);
              print("Tag deleted from backend: $plantsTagId");
              await plantsTagRepository.deletePlantTag(plantsTagId);
            } catch (e) {
              print("Error deleting plant tag: $e");
            }
          } else if (!backendPlantsTagMap.containsKey(plantsTagId)) {
            await plantsTagApiService
                .createPlantsTagApi(localPlantsTag!.toJson());
          } /*else if (localPlantsTag.updatedAt
              .isAfter(backendPlantsTagMap[plantsTagId]!.updatedAt)) {
            await plantsTagApiService.updatePlantsTagApi(
                localPlantsTag!.toJson(), localPlantsTag.id);
          }*/
        }

        for (var plantsTagId in backendPlantsTagMap.keys) {
          final backendPlantsTag = backendPlantsTagMap[plantsTagId];
          if (!localPlantsTagMap.containsKey(plantsTagId)) {
            await plantsTagRepository.insertPlantsTag(backendPlantsTag!);
          } /*else if (backendPlantsTag.updatedAt
              .isAfter(localPlantsTagMap[plantsTagId]!.updatedAt)) {
            await plantsTagRepository.updatePlantsTag(backendPlantsTag!);
          }*/
        }

        pt = await plantsTagRepository.fetchAllPlantTags(plantId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'plant_tags',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Plant tag sync completed successfully for plantId: $plantId',
        ));
        notifyListeners();
        print(
            "Plant tag sync completed successfully for plantId: $plantId");
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
