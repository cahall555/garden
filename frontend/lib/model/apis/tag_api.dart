import 'dart:convert';
import 'package:http/http.dart' as http;
import '../tag.dart';

Future<List<Tag>> fetchTag(String tagId) async {
  final response = await http.get(Uri.parse('http://localhost:3000/tags/$tagId'));

  if (response.statusCode == 200) {
	final data = jsonDecode(response.body);

  	if (data is Map) {
    		return [Tag.fromJson(Map<String, dynamic>.from(data))];
  	} else if (data is List) {
    		return data.map<Tag>((json) => Tag.fromJson(Map<String, dynamic>.from(json))).toList();

	} else {
      throw Exception('Unexpected JSON format: ${response.body}');
    }
  } else {
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

