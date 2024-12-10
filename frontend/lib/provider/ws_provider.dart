import 'package:flutter/widgets.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';
import 'package:frontend/services/repositories/ws_repository.dart';
import 'package:frontend/services/connection_status.dart';

class WsProvider with ChangeNotifier {
  List<WaterSchedule> wsList = [];
  WaterSchedule? prevWs;
  final wsApiService;
  final WaterScheduleRepository wsRepository;

  WsProvider(this.wsApiService, this.wsRepository);


  Future<List<WaterSchedule>> fetchWs(var plantId) async {
    try {
     wsList = await wsRepository.fetchAllWaterSchedules(plantId);
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
    wsApiService.createWsApi(ws, plantId);
    notifyListeners();
  }

  Future<void> updateWs(
      Map<String, dynamic> wsData, var plantId, var wsId) async {
    await wsApiService.updateWsApi(wsData, plantId, wsId);

    if (prevWs != null) {
      int index = wsList.indexWhere((w) => w.id == prevWs!.id);

      if (index != -1) {
        wsList[index] = WaterSchedule.fromJson(wsData);
      }
    }
    notifyListeners();
  }

  Future<void> deleteWs(var wsId) async {
    await wsApiService.deleteWsApi(wsId);
    notifyListeners();
  }
 Future<void> syncWithBackend(var plantId) async {
    if (await isOnline()) {
      try {
        final wsFromBackend =
            await wsApiService.fetchWsApi(plantId);
        for (var ws in wsFromBackend) {
          await wsRepository.insertWaterSchedule(ws);
        }
        wsList = await wsRepository.fetchAllWaterSchedules(plantId);
        notifyListeners();
      } catch (e) {
        print('Error syncing with backend: $e');
      }
    } else {
      print('Offline: Sync skipped');
    }
  }

  Future<bool> isOnline() async {
 //  return await ConnectionStatusSingleton.getInstance().checkConnection();
	  return true;
  }

}
