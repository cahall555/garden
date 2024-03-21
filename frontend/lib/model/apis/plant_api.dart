import 'dart:convert';
import 'package:http/http.dart' as http;
import '../plant.dart';

Future<List<Plant>> fetchPlant(String id) async {
  final response = await http.get(Uri.parse('http://localhost:3000/plants/${id}'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<Plant>((json) => Plant.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<List<Plant>> fetchPlants(String gardenId) async {
  final response = await http.get(Uri.parse('http://localhost:3000/plants?garden_id=$gardenId'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Plant>((json) => Plant.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

