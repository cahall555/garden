import 'dart:convert';
import 'package:http/http.dart' as http;
import '../plant.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

final String apiUrl = dotenv.env['API_URL']!;

class PlantApiService {
  final http.Client client;
  PlantApiService(this.client);

  String formatDate(String date) {
    final parsedDate = DateTime.parse(date);
    final formatter = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    return formatter.format(parsedDate);
  }

  Future<List<Plant>> fetchPlantApi(String id) async {
    final response = await client.get(Uri.parse(apiUrl + 'plants/${id}'));

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
    final response =
        await client.get(Uri.parse(apiUrl + 'plants?garden_id=$gardenId'));

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

  Future<void> createPlantApi(
      Map<String, dynamic> plantData, var gardenId) async {
    final url = Uri.parse(apiUrl + 'plants?gardenId=$gardenId');
    final headers = {"Content-Type": "application/json"};

    if (plantData['date_planted'] == "") {
      plantData.remove('date_planted');
    }
    if (plantData['date_germinated'] == "") {
      plantData.remove('date_germinated');
    }

    if (plantData['date_planted'] != null && plantData['date_planted'] != "") {
      plantData['date_planted'] = formatDate(plantData['date_planted']);
    }
    if (plantData['date_germinated'] != null &&
        plantData['date_germinated'] != "") {
      plantData['date_germinated'] = formatDate(plantData['date_germinated']);
    }

    print("***Date Planted: $plantData");
    try {
      final response =
          await client.post(url, headers: headers, body: json.encode(plantData));

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

  Future<void> updatePlantApi(Map<String, dynamic> plantData) async {
    final url = Uri.parse(apiUrl + 'plants?id=${plantData['id']}');
    final headers = {"Content-Type": "application/json"};

    if (plantData['date_planted'] != null && plantData['date_planted'] != "") {
      plantData['date_planted'] = formatDate(plantData['date_planted']);
    }
    if (plantData['date_germinated'] != null &&
        plantData['date_germinated'] != "") {
      plantData['date_germinated'] = formatDate(plantData['date_germinated']);
    }

    try {
      final response =
          await client.put(url, headers: headers, body: json.encode(plantData));

      if (response.statusCode == 200) {
        print('Plant updated successfully');
      } else {
        print('Failed to update plant: ${response.body}');
        throw Exception('Failed to update plant');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> deletePlantApi(var plantId) async {
    final url = Uri.parse(apiUrl + 'plants/$plantId?id=$plantId');
    final headers = {"Content-Type": "application/json"};

    try {
      final response = await client.delete(url, headers: headers);

      if (response.statusCode == 200) {
        print('Plant deleted successfully');
      } else {
        print('Failed to delete plant: ${response.body}');
        throw Exception('Failed to delete plant');
      }
    } catch (e) {
      print(e.toString());
    }
  }
}
