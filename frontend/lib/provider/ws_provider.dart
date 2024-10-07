import 'package:flutter/widgets.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';

class WsProvider with ChangeNotifier {
  List<WaterSchedule> wsList = [];
  WaterSchedule? prevWs;
  final wsApiService;
  WsProvider(this.wsApiService);


  Future<List<WaterSchedule>> fetchWs(var plantId) async {
    try {
      wsList = await wsApiService.fetchWsApi(plantId);
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
}
