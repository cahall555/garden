import 'package:flutter/widgets.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';

class JournalProvider with ChangeNotifier {
  List<Journal> journals = [];
  Journal? prevJournal;

  Future<List<Journal>> fetchJournal() async {
    try {
      journals = await fetchJournalApi();
      notifyListeners();
      return journals;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Journal>> fetchPlantJournal(var plantId) async {
    try {
      journals = await fetchPlantJournalApi(plantId);
      notifyListeners();
      return journals;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createJournal(Map<String, dynamic> journal, var plantId, String? filePath) async {
    createJournalApi(journal, plantId, filePath);	
    notifyListeners();
  }

//  Future<void> updateWs(Map<String, dynamic> wsData, var plantId, var wsId) async {
//    await updateWsApi(wsData, plantId, wsId);

//    if (prevWs != null) {
//    	int index = wsList.indexWhere((w) => w.id == prevWs!.id);

//    	if (index != -1) {
//      		wsList[index] = WaterSchedule.fromJson(wsData);
//    	}
//    }
//    notifyListeners();
//}
//Future<void> deleteWs(var wsId) async {
//	await deleteWsApi(wsId);
//	notifyListeners();
//}
}
