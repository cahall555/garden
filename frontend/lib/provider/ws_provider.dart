import 'package:flutter/widgets.dart';
import '../model/ws.dart';
import '../model/apis/ws_api.dart';

class WsProvider with ChangeNotifier {
  List<WaterSchedule> wsList = [];
  WaterSchedule? prevWs;

  Future<void> createWs(Map<String, dynamic> ws, var plantId) async {
    createWsApi(ws, plantId);
    notifyListeners();
  }

  Future<void> updateWs(
      Map<String, dynamic> wsData, var plantId, var wsId) async {
    await updateWsApi(wsData, plantId, wsId);

    if (prevWs != null) {
      int index = wsList.indexWhere((w) => w.id == prevWs!.id);

      if (index != -1) {
        wsList[index] = WaterSchedule.fromJson(wsData);
      }
    }
    notifyListeners();
  }

  Future<void> deleteWs(var wsId) async {
    await deleteWsApi(wsId);
    notifyListeners();
  }
}
