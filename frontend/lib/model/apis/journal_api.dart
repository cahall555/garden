import 'dart:convert';
import 'package:http/http.dart' as http;
import '../journal.dart';

Future<List<Journal>> fetchJournal() async {
  final response = await http.get(Uri.parse('http://localhost:3000/journals'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<Journal>((json) => Journal.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<List<Journal>> fetchPlantJournal(String plantId) async {
  final response = await http.get(Uri.parse('http://localhost:3000/journals?plant_id=$plantId'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<Journal>((json) => Journal.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}
