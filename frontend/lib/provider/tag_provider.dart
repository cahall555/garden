import 'package:flutter/widgets.dart';
import '../model/tag.dart';
import '../model/sync_log.dart';
import '../model/apis/tag_api.dart';
import 'package:provider/provider.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';
import 'plants_tag_provider.dart';
import 'package:frontend/services/repositories/tag_repository.dart';
import 'package:frontend/services/repositories/plants_tag_repository.dart';
import 'package:frontend/services/repositories/sync_repository.dart';
import 'package:frontend/services/connection_status.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  Tag? tag;
  final tagApiService;
  final plantsTagApiService;
  final TagRepository tagRepository;
  final PlantsTagRepository plantsTagRepository;
  final SyncLogRepository syncLogRepository;
  TagProvider(this.tagApiService, this. plantsTagApiService, this.tagRepository, this.plantsTagRepository, this.syncLogRepository);

  Future<List<Tag>> fetchTags(var accountId) async {
    try {
      await syncWithBackend(accountId);
      tags = await tagRepository.fetchAllTags(accountId);
      if (tags.isEmpty) {
        tags = await tagApiService.fetchTagsApi(accountId);
        for (var tag in tags) {
          tagRepository.insertTag(tag);
        }
      }
      notifyListeners();
      return tags;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Tag>> fetchTag(var tagId) async {
    try {
	    print("fetching local tag with id: $tagId");
      tags = await tagRepository.fetchTagId(tagId);
      print('Tag fetched from local: $tags');
      if (tags.isNotEmpty) {
	      print('Tags is not empty');
      } else if (tags.isEmpty) {
	      print('Tags is empty');
        tags = await tagApiService.fetchTagApi(tagId);
        for (var tag in tags) {
          tagRepository.insertTag(tag);
        }
      }
      notifyListeners();
      return tags;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Tag?> fetchTagByName(String name, var accountId) async {
    try {
      tag = await tagRepository.fetchTagName(name, accountId);
      print('Tag name fetched from local: $tag');
      // List<Tag> tags = await tagApiService.fetchTagByNameApi(name, accountId);
      if (tags.isNotEmpty) {
        return tags[0];
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<Tag> createTag(Map<String, dynamic> tag) async {
    try {
      if (tag.isNotEmpty) {
	      print('creating tag: $tag');
        final newTag = Tag.fromJson(tag);
	print('new tag from json: $newTag');
        await tagRepository.insertTag(newTag);
        await syncWithBackend(tag['account_id']);
        return newTag;
      } else {
        throw Exception('Tag data is empty');
      }
    } catch (e) {
      throw Exception('Failed to create tag: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> updateTag(Map<String, dynamic> tagData, var tagId) async {
    try {
      final updatedTag = Tag.fromJson(tagData);
      await tagRepository.updateTag(updatedTag);
      await syncWithBackend(tagData['account_id']);
//      await tagApiService.updateTagApi(tagData, tagId);
    } catch (e) {
      throw Exception('Failed to update tag: $e');
    } finally {
      notifyListeners();
    }
  }

  Future<void> deleteTag(Map<String, dynamic> tag) async {
    try {
      print("isOnline when delete is triggered: ${await isOnline()}");
      if (await isOnline()) {
        await tagApiService.deleteTagApi(tag['id']);
        print("Tag deleted from backend: ${tag['id']}");
        await tagRepository.deleteTag(tag['id']);
      } else {
        print("Offline: Marking tag for deletion locally");
        await tagRepository.markForDeletion(tag['id']);
      }

      await syncWithBackend(tag['account_id']);
    } catch (e) {
      print("Error deleting tag: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<void> syncWithBackend(var accountId) async {
    if (await isOnline()) {
      try {
        print("Syncing tags for accountId: $accountId");

        final syncLog = await syncLogRepository.getSyncLog('tags');
        final lastSyncTime = syncLog?.lastSyncTime;

	print("starting sync with backend for accountId: $accountId");
        final tagsFromBackend = await tagApiService.fetchTagsApi(accountId);
	print("tags from backend: $tagsFromBackend");

	print("fetching local tags for accountId: $accountId");
        final tagsFromLocal = await tagRepository.fetchAllTags(accountId);
	print("tags from local: $tagsFromLocal");

        final backendTagMap = {for (var tag in tagsFromBackend) tag.id: tag};
        final localTagMap = {for (var tag in tagsFromLocal) tag.id: tag};

        for (var tagId in localTagMap.keys) {
          final localTag = localTagMap[tagId];
          print("Local tag marked for deletion: ${localTag?.toJson()}");
          if (localTag!.marked_for_deletion == 1) {
            try {
              await tagApiService.deleteTagApi(tagId);
              print("Tag deleted from backend: $tagId");
              await tagRepository.deleteTag(tagId);
            } catch (e) {
              print("Error deleting tag: $e");
            }
          } else if (!backendTagMap.containsKey(tagId)) {
		  print("creating tag in backend: ${localTag!.toJson()}");
            await tagApiService.createTagApi(localTag!.toJson());
          } else if (localTag.updatedAt
              .isAfter(backendTagMap[tagId]!.updatedAt)) {
            await tagApiService.updateTagApi(localTag!.toJson(), localTag.id);
          }
        }

        for (var tagId in backendTagMap.keys) {
          final backendTag = backendTagMap[tagId];
          if (!localTagMap.containsKey(tagId)) {
            await tagRepository.insertTag(backendTag!);
          } else if (backendTag.updatedAt
              .isAfter(localTagMap[tagId]!.updatedAt)) {
            await tagRepository.updateTag(backendTag!);
          }
        }

        tags = await tagRepository.fetchAllTags(accountId);
        await syncLogRepository.saveSyncLog(SyncLog(
          entity: 'tags',
          lastSyncTime: DateTime.now().toUtc(),
          lastSyncStatus: 'success',
          lastSyncMessage:
              'Tag sync completed successfully for accountId: $accountId',
        ));
        notifyListeners();
        print("Tag sync completed successfully for accountId: $accountId");
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
