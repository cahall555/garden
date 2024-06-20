import 'package:flutter/widgets.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';

class PlantsTagProvider with ChangeNotifier {
  List<PlantTags> pt = [];
  //Tag? prevTag;
  final plantsTagApiService;
  PlantsTagProvider(this.plantsTagApiService);

  Future<List<PlantTags>> fetchPlantsTag(var plantId) async {
    try {
      pt = await plantsTagApiService.fetchPlantsTagApi(plantId);
      notifyListeners();
      return pt;
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<void> createPlantsTag(Map<String, dynamic> plantTag) async {
    try {
      await plantsTagApiService.createPlantsTagApi(plantTag);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
