import 'package:flutter/widgets.dart';
import '../model/tag.dart';
import '../model/apis/tag_api.dart';

class TagProvider with ChangeNotifier {
  List<Tag> tags = [];
  //Tag? prevTag;

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

  Future<void> createTag(Map<String, dynamic> tag) async {
    createTagApi(tag);
    notifyListeners();
  }
}
