import 'dart:convert';
import 'package:http/http.dart' as http;
import '../plant.dart';

Future<List<Plant>> fetchPlantApi(String id) async {
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

Future<List<Plant>> fetchPlantsApi(String gardenId) async {
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

Future<void> createPlantApi(Map<String, dynamic> plantData, var gardenId) async {
  	final url = Uri.parse('http://localhost:3000/plants?gardenId=$gardenId');
  	final headers = {"Content-Type": "application/json"};
	 
	try{
  		final response = await http.post(url, headers: headers, body: json.encode(plantData));

  		if (response.statusCode == 201) {
    			print('Plant created successfully');
  		} else {
    			print('Failed to create plant: ${response.body}');
    			throw Exception('Failed to create plant');
  		}
	} catch (e) {
		print(e.toString());
	}
}
