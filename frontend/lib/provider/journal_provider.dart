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

  Future<void> createJournal(
      Map<String, dynamic> journal, var plantId, String? filePath) async {
    createJournalApi(journal, plantId, filePath);
    notifyListeners();
  }

  Future<void> updateJournal(
      Map<String, dynamic> journal, var journalId, var plantId, String? filePath) async {
    updateJournalApi(journal, journalId, plantId, filePath);
    notifyListeners();
    if (prevJournal != null) {
      int index = journals.indexWhere((j) => j.id == prevJournal!.id);

      if (index != -1) {
        journals[index] = Journal.fromJson(journal);
      }
    }
  }

  Future<void> deleteJournal(var journalId) async {
    deleteJournalApi(journalId);
    notifyListeners();
    journals.removeWhere((j) => j.id == journalId);
  }
}
