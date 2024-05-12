import 'package:flutter/widgets.dart';
import '../model/farm.dart';
import '../model/apis/farm_api.dart';

class FarmProvider with ChangeNotifier {
  List<Farm> farms = [];
  Farm? prevFarm;

Future <List<Farm>> fetchFarms(var accountId) async {
    try {
      farms = await fetchFarmsApi(accountId);
      notifyListeners();
      return farms;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createFarm(Map<String, dynamic> farm, var accountId) async {
    createFarmApi(farm, accountId);
    notifyListeners();
  }

  Future<void> updateFarm(Map<String, dynamic> farm, var farmId) async {
    updateFarmApi(farm, farmId);
    notifyListeners();
  }

  Future<void> deleteFarm(var farmId) async {
    deleteFarmApi(farmId);
    notifyListeners();
  }
}
