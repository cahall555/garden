import 'package:flutter/widgets.dart';
import '../model/journal.dart';
import '../model/apis/journal_api.dart';
import 'package:frontend/services/repositories/journal_repository.dart';
import 'package:frontend/services/connection_status.dart';

class JournalProvider with ChangeNotifier {
  List<Journal> journals = [];
  Journal? prevJournal;
  final journalApiService;
  final JournalRepository journalRepository;
 
  JournalProvider(this.journalApiService, this.journalRepository);

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
	journals = await journalRepository.fetchAllJournals(plantId);
      if (journals.isEmpty) {
        journals = await journalApiService.fetchPlantJournalApi(plantId);
        for (var journal in journals) {
          journalRepository.insertJournal(journal);
        }
      }
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
Future<void> syncWithBackend(var plantId) async {
    if (await isOnline()) {
      try {
        final journalsFromBackend =
            await journalApiService.fetchPlantJournalApi(plantId);
        for (var journal in journalsFromBackend) {
          await journalRepository.insertJournal(journal);
        }
        journals = await journalRepository.fetchAllJournals(plantId);
        notifyListeners();
      } catch (e) {
        print('Error syncing with backend: $e');
      }
    } else {
      print('Offline: Sync skipped');
    }
  }

  Future<bool> isOnline() async {
//	return await ConnectionStatusSingleton.getInstance().checkConnection();
	  return true;

  }
}
