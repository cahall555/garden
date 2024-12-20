import 'package:flutter/widgets.dart';
import '../model/journal.dart';
import '../model/sync_log.dart';
import '../model/apis/journal_api.dart';
import 'package:frontend/services/repositories/journal_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class JournalProvider with ChangeNotifier {
  List<Journal> journals = [];
  Journal? prevJournal;
  final journalApiService;
  final JournalRepository journalRepository;
  final SyncLogRepository syncLogRepository;

  JournalProvider(
      this.journalApiService, this.journalRepository, this.syncLogRepository);

  Future<List<Journal>> fetchJournal() async {
    try {
   //   await syncWithBackend(var plantId);
      journals = await journalRepository.fetchJournals();
      if (journals.isEmpty) {
        journals = await journalApiService.fetchJournalApi();
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

  Future<List<Journal>> fetchPlantJournal(var plantId) async {
    try {
      await syncWithBackend(plantId);
      journals = await journalRepository.fetchCurrentJournals(plantId);
      print("Journals: ${journals.length}");
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
    try {
      print("journal: $journal");
      final newJournal = Journal.fromJson(journal);
      await journalRepository.insertJournal(newJournal);
      await syncWithBackend(plantId);
    } catch (e) {
      print('error creating journal: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateJournal(Map<String, dynamic> journal, var journalId,
      var plantId, String? filePath) async {
    try {
      final updateJournal = Journal.fromJson(journal);
      await journalRepository.updateJournal(updateJournal);
      await syncWithBackend(plantId);
    } catch (e) {
      print('error updating journal: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteJournal(Journal journal) async {
    try {
      print("isOnline when delete is triggered: ${await isOnline()}");
      if (await isOnline()) {
        await journalApiService.deleteJournalApi(journal.id);
        print("Journal deleted from backend: ${journal.id}");
        await journalRepository.deleteJournal(journal.id);
      } else {
        print("Offline: Marking journal for deletion locally");
        await journalRepository.markForDeletion(journal.id);
      }

      await syncWithBackend(journal.plant_id);
    } catch (e) {
      print("Error deleting garden: $e");
    } finally {
      notifyListeners();
    }
    //   journals.removeWhere((j) => j.id == journalId);
  }

  Future<void> syncWithBackend(var plantId) async {
    if (await isOnline()) {
      try {
        print("Syncing journals for plantId: $plantId");

        final syncLog = await syncLogRepository.getSyncLog('journals');
        final lastSyncTime = syncLog?.lastSyncTime;

        final journalsFromBackend =
            await journalApiService.fetchPlantJournalApi(plantId);

        final journalsFromLocal =
            await journalRepository.fetchAllJournals(plantId);

        final backendJournalMap = {
          for (var journal in journalsFromBackend) journal.id: journal
        };
        final localJournalMap = {
          for (var journal in journalsFromLocal) journal.id: journal
        };

        for (var journalId in localJournalMap.keys) {
          final localJournal = localJournalMap[journalId];
          final image = localJournalMap[journalId]!.image;

          if (localJournal!.marked_for_deletion == 1) {
            try {
              await journalApiService.deleteJournalApi(journalId);
              print("Journal deleted from backend: $journalId");
              await journalRepository.deleteJournal(journalId);
            } catch (e) {
              print("Error deleting journal: $e");
            }
          } else if (!backendJournalMap.containsKey(journalId)) {
            await journalApiService.createJournalApi(
                localJournal!.toJson(), plantId, image);
          } else if (localJournal.updatedAt
              .isAfter(backendJournalMap[journalId]!.updatedAt)) {
            await journalApiService.updateJournalApi(
                localJournal!.toJson(), journalId, plantId, image);
          }
        }

        for (var journalId in backendJournalMap.keys) {
          final backendJournal = backendJournalMap[journalId];
          if (!localJournalMap.containsKey(journalId)) {
            await journalRepository.insertJournal(backendJournal!);
          } else if (backendJournal.updatedAt
              .isAfter(localJournalMap[journalId]!.updatedAt)) {
            await journalRepository.updateJournal(backendJournal!);
          }
        }

        journals = await journalRepository.fetchAllJournals(plantId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'journals',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Sync completed successfully for journals with plantId: $plantId',
        ));
        notifyListeners();
        print(
            "Sync completed successfully for journals with plantId: $plantId");
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
