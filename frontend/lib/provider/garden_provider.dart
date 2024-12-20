import 'package:flutter/widgets.dart';
import '../model/garden.dart';
import '../model/sync_log.dart';
import '../model/apis/garden_api.dart';
import 'package:frontend/services/repositories/garden_repository.dart';
import 'package:frontend/services/repositories/plant_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class GardenProvider with ChangeNotifier {
  List<Garden> gardens = [];
  Garden? prevGarden;
  final gardenApiService;
  final SyncLogRepository syncLogRepository;
  final GardenRepository gardenRepository;

  GardenProvider(
      this.gardenApiService, this.gardenRepository, this.syncLogRepository);

  Future<List<Garden>> fetchGarden(var accountId) async {
    try {
      await syncWithBackend(accountId);
      gardens = await gardenRepository.fetchCurrentGardens(accountId);
      if (gardens.isEmpty) {
        gardens = await gardenApiService.fetchGardenApi(accountId);
        for (var garden in gardens) {
          gardenRepository.insertGarden(garden);
        }
      }
      notifyListeners();
      return gardens;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createGarden(Map<String, dynamic> garden) async {
    try {
      final newGarden = Garden.fromJson(garden);
      await gardenRepository.insertGarden(newGarden);
      await syncWithBackend(newGarden.id);
    } catch (e) {
      print('error creating garden: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateGarden(Map<String, dynamic> garden, var gardenId) async {
    try {
      final updateGarden = Garden.fromJson(garden);
      await gardenRepository.updateGarden(updateGarden, gardenId);
      await syncWithBackend(garden['account_id']);
    } catch (e) {
      print('error updating garden: $e');
    } finally {
      notifyListeners();
      if (prevGarden != null) {
        int index = gardens.indexWhere((g) => g.id == prevGarden!.id);

        if (index != -1) {
          gardens[index] = Garden.fromJson(garden);
        }
      }
    }
  }

  Future<void> deleteGarden(Garden garden) async {
    try {
      print("isOnline when delete is triggered: ${await isOnline()}");
      if (await isOnline()) {
        await gardenApiService.deleteGardenApi(garden.id);
        print("Garden deleted from backend: ${garden.id}");
        await gardenRepository.deleteGarden(garden.id);
      } else {
        print("Offline: Marking garden for deletion locally");
        await gardenRepository.markForDeletion(garden.id);
      }

      await syncWithBackend(garden.account_id);
    } catch (e) {
      print("Error deleting garden: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> syncWithBackend(var accountId) async {
    if (await isOnline()) {
      try {
        print("Syncing gardens for accountId: $accountId");

        final syncLog = await syncLogRepository.getSyncLog('gardens');
        final lastSyncTime = syncLog?.lastSyncTime;

        final gardensFromBackend =
            await gardenApiService.fetchGardenApi(accountId);

        final gardensFromLocal =
            await gardenRepository.fetchAllGardens(accountId);

        final backendGardenMap = {
          for (var garden in gardensFromBackend) garden.id: garden
        };
        final localGardenMap = {
          for (var garden in gardensFromLocal) garden.id: garden
        };

        for (var gardenId in localGardenMap.keys) {
          final localGarden = localGardenMap[gardenId];
          print("Local garden marked for deletion: ${localGarden?.toJson()}");
          if (localGarden!.marked_for_deletion == 1) {
            try {
              await gardenApiService.deleteGardenApi(gardenId);
              print("Garden deleted from backend: $gardenId");
              await gardenRepository.deleteGarden(gardenId);
            } catch (e) {
              print("Error deleting garden: $e");
            }
          } else if (!backendGardenMap.containsKey(gardenId)) {
            await gardenApiService.createGardenApi(localGarden!.toJson());
          } else if (localGarden.updatedAt
              .isAfter(backendGardenMap[gardenId]!.updatedAt)) {
            await gardenApiService.updateGardenApi(
                localGarden!.toJson(), localGarden.id);
          }
        }

        for (var gardenId in backendGardenMap.keys) {
          final backendGarden = backendGardenMap[gardenId];
          if (!localGardenMap.containsKey(gardenId)) {
            await gardenRepository.insertGarden(backendGarden!);
          } else if (backendGarden.updatedAt
              .isAfter(localGardenMap[gardenId]!.updatedAt)) {
            await gardenRepository.updateGarden(backendGarden!, gardenId);
          }
        }

        gardens = await gardenRepository.fetchAllGardens(accountId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'gardens',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Sync completed successfully for accountId: $accountId',
        ));
        notifyListeners();
        print("Sync completed successfully for accountId: $accountId");
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
