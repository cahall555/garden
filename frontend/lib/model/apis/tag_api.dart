import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tag.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class TagApiService {
  final http.Client client;
  TagApiService(this.client);

  Future<List<Tag>> fetchTagApi(var tagId) async {
    final response = await client.get(Uri.parse(apiUrl + 'tags/$tagId'));

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

  Future<List<Tag>> fetchTagByNameApi(String name, var accountId) async {
    final response = await client
        .get(Uri.parse(apiUrl + 'tag/$name?name=$name&account_id=$accountId'));

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

  Future<List<Tag>> fetchTagsApi(var accountId) async {
    final response =
        await client.get(Uri.parse(apiUrl + 'tags?account_id=$accountId'));

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
          await client.post(url, headers: headers, body: json.encode(tagData));

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
      final response =
          await client.put(url, headers: headers, body: json.encode(tagData));

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
      final response = await client.delete(url, headers: headers);

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
}
