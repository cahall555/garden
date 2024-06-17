import 'package:flutter/widgets.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';

class JournalProvider with ChangeNotifier {
  List<Journal> journals = [];
  Journal? prevJournal;
  final journalApiService;
  JournalProvider(this.journalApiService);

  Future<List<Journal>> fetchJournal() async {
    try {
      journals = await journalApiService.fetchJournalApi();
      notifyListeners();
      return journals;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Journal>> fetchPlantJournal(var plantId) async {
    try {
      journals = await journalApiService.fetchPlantJournalApi(plantId);
      notifyListeners();
      return journals;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createJournal(
      Map<String, dynamic> journal, var plantId, String? filePath) async {
    journalApiService.createJournalApi(journal, plantId, filePath);
    notifyListeners();
  }

  Future<void> updateJournal(
      Map<String, dynamic> journal, var journalId, var plantId, String? filePath) async {
    journalApiService.updateJournalApi(journal, journalId, plantId, filePath);
    notifyListeners();
    print('provider journal ');
  }

  Future<void> deleteJournal(var journalId) async {
    journalApiService.deleteJournalApi(journalId);
    notifyListeners();
    journals.removeWhere((j) => j.id == journalId);
  }
}
