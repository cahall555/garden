import 'package:flutter/widgets.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';
import 'package:provider/provider.dart';
import '../model/plants_tag.dart';
import '../model/apis/plants_tag_api.dart';
import 'plants_tag_provider.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  Tag? newTag;

  Future<List<Tag>> fetchTags() async {
    try {
      tags = await fetchTagsApi();
      notifyListeners();
      return tags;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Tag>> fetchTag(var tagId) async {
    try {
      tags = await fetchTagApi(tagId);
      notifyListeners();
      return tags;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Tag> createTag(Map<String, dynamic> tag) async {
    try {
      newTag = await createTagApi(tag);
      notifyListeners();
      return newTag!;
    } catch (e) {
      print(e);
      throw Exception('Failed to create tag');
    }
  }

  Future<void> updateTag(Map<String, dynamic> tagData, var tagId) async {
    try {
      await updateTagApi(tagData, tagId);
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Failed to update tag');
    }
  }

  Future<void> deleteTag(var tagId) async {
    try {
      await deleteTagApi(tagId);
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Failed to delete tag');
    }
  }
}
