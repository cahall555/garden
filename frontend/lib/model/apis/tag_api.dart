import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tag.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;


Future<List<Tag>> fetchTagApi(var tagId) async {
  final response =
      await http.get(Uri.parse(apiUrl + 'tags/$tagId'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data is Map) {
      return [Tag.fromJson(Map<String, dynamic>.from(data))];
    } else if (data is List) {
      return data
          .map<Tag>((json) => Tag.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw Exception('Unexpected JSON format: ${response.body}');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<List<Tag>> fetchTagsApi() async {
  final response = await http.get(Uri.parse(apiUrl + 'tags'));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);

    if (data is Map) {
      return [Tag.fromJson(Map<String, dynamic>.from(data))];
    } else if (data is List) {
      return data
          .map<Tag>((json) => Tag.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw Exception('Unexpected JSON format: ${response.body}');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<Tag> createTagApi(Map<String, dynamic> tagData) async {
  final url = Uri.parse(apiUrl + 'tags');
  final headers = {"Content-Type": "application/json"};
  try {
    final response =
        await http.post(url, headers: headers, body: json.encode(tagData));

    if (response.statusCode == 200) {
      return Tag.fromJson(jsonDecode(response.body));
      print('Tag created successfully');
    } else {
      print('Failed to create tag: ${response.body}');
      throw Exception('Failed to create tag');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to create tag: $e');
  }
}

Future<void> updateTagApi(Map<String, dynamic> tagData, var tagId) async {
  final url = Uri.parse(apiUrl + 'tags?tagId=$tagId');
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.put(url, headers: headers, body: json.encode(tagData));

    if (response.statusCode == 200) {
      print('Tag updated successfully');
    } else {
      print('Failed to update tag: ${response.body}');
      throw Exception('Failed to update tag');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to update tag: $e');
  }
}

Future<void> deleteTagApi(var tagId) async {
  final url = Uri.parse(apiUrl + 'tags/$tagId');
  final headers = {"Content-Type": "application/json"};
  try {
    final response = await http.delete(url, headers: headers);

    if (response.statusCode == 200) {
      print('Tag deleted successfully');
    } else {
      print('Failed to delete tag: ${response.body}');
      throw Exception('Failed to delete tag');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Failed to delete tag: $e');
  }
}
