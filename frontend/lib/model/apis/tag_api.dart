import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tag.dart';

Future<List<Tag>> fetchTagApi(var tagId) async {
  final response =
      await http.get(Uri.parse('http://localhost:3000/tags/$tagId'));

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
  final response = await http.get(Uri.parse('http://localhost:3000/tags'));

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

Future<void> createTagApi(Map<String, dynamic> tagData) async {
  final url = Uri.parse('http://localhost:3000/tags');
  final headers = {
    "Content-Type": "application/json"
  };
  try {
    final response =
        await http.post(url, headers: headers, body: json.encode(tagData));

    if (response.statusCode == 201) {
      print('Tag created successfully');
    } else {
      print('Failed to create tag: ${response.body}');
      throw Exception('Failed to create tag');
    }
  } catch (e) {
    print(e.toString());
  }
}
