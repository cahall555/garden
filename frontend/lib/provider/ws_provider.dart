import 'package:flutter/widgets.dart';
import '../model/ws.dart';
import '/model/sync_log.dart';
import '../model/apis/ws_api.dart';
import 'package:frontend/services/repositories/ws_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class WsProvider with ChangeNotifier {
  List<WaterSchedule> wsList = [];
  WaterSchedule? prevWs;
  final wsApiService;
  final SyncLogRepository syncLogRepository;
  final WaterScheduleRepository wsRepository;

  WsProvider(this.wsApiService, this.wsRepository, this.syncLogRepository);

  Future<List<WaterSchedule>> fetchWs(var plantId) async {
    try {
      await syncWithBackend(plantId);
      wsList = await wsRepository.fetchCurrentWaterSchedules(plantId);
      if (wsList.isEmpty) {
        wsList = await wsApiService.fetchWsApi(plantId);
        for (var ws in wsList) {
          wsRepository.insertWaterSchedule(ws);
        }
      }
      notifyListeners();
      return wsList;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createWs(Map<String, dynamic> ws, var plantId) async {
    try {
      final newWs = WaterSchedule.fromJson(ws);
      await wsRepository.insertWaterSchedule(newWs);
      await syncWithBackend(plantId);
    } catch (e) {
      print('error creating ws: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateWs(
      Map<String, dynamic> wsData, var plantId, var wsId) async {
    try {
      final updatedWs = WaterSchedule.fromJson(wsData);
      await wsRepository.updateWaterSchedule(updatedWs);
      await syncWithBackend(plantId);
    } catch (e) {
      print('error updating ws: $e');
    } finally {
      notifyListeners();
      if (prevWs != null) {
        int index = wsList.indexWhere((w) => w.id == prevWs!.id);

        if (index != -1) {
          wsList[index] = WaterSchedule.fromJson(wsData);
        }
      }
    }
  }

  Future<void> deleteWs(var wsId, var plantId) async {
    try {
      print("isOnline when delete is triggered: ${await isOnline()}");
      if (await isOnline()) {
        await wsApiService.deleteWsApi(wsId);
        print("Water schedule deleted from backend: ${wsId}");
        await wsRepository.deleteWaterSchedule(wsId);
      } else {
        print("Offline: Marking water schedule for deletion locally");
        await wsRepository.markForDeletion(wsId);
      }

      await syncWithBackend(plantId);
    } catch (e) {
      print("Error deleting water schedule: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> syncWithBackend(var plantId) async {
    if (await isOnline()) {
      try {
        print("Syncing water schedule for plantId: $plantId");

        final syncLog = await syncLogRepository.getSyncLog('water_schedules');
        final lastSyncTime = syncLog?.lastSyncTime;
        print("Starting ws from backend");
        final wsFromBackend = await wsApiService.fetchWsApi(plantId);
            final wsFromLocal = await wsRepository.fetchAllWaterSchedules(plantId);

        final backendWsMap = {for (var ws in wsFromBackend) ws.id: ws};
        final localWsMap = {for (var ws in wsFromLocal) ws.id: ws};

        for (var wsId in localWsMap.keys) {
          final localWs = localWsMap[wsId];
          print(
              "Local water schedule marked for deletion: ${localWs?.toJson()}");
          if (localWs!.marked_for_deletion == 1) {
            try {
              await wsApiService.deleteWsApi(wsId);
              print("Water schedule deleted from backend: $wsId");
              await wsRepository.deleteWaterSchedule(wsId);
            } catch (e) {
              print("Error deleting water schedule: $e");
            }
          } else if (!backendWsMap.containsKey(wsId)) {
            await wsApiService.createWsApi(localWs!.toJson(), plantId);
          } else if (localWs.updatedAt.isAfter(backendWsMap[wsId]!.updatedAt)) {
            await wsApiService.updateWsApi(localWs!.toJson(), plantId, wsId);
          }
        }

        for (var wsId in backendWsMap.keys) {
          final backendWs = backendWsMap[wsId];
          if (!localWsMap.containsKey(wsId)) {
            await wsRepository.insertWaterSchedule(backendWs!);
          } else if (backendWs.updatedAt.isAfter(localWsMap[wsId]!.updatedAt)) {
            await wsRepository.updateWaterSchedule(backendWs!);
          }
        }

        wsList = await wsRepository.fetchAllWaterSchedules(plantId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'water_schedules',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Sync completed successfully for water schedules with plantId: $plantId',
        ));
        notifyListeners();
        print(
            "Sync completed successfully for water schedules with plantId: $plantId");
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
