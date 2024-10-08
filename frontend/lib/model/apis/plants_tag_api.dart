import 'dart:convert';
import 'package:http/http.dart' as http;
import '../plants_tag.dart';
import 'custom_exception.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class PlantsTagApiService {
  final http.Client client;
  PlantsTagApiService(this.client);

  Future<List<PlantTags>> fetchPlantsTagApi(var plantId) async {
    final uri = Uri.parse(apiUrl + 'plantstag?plant_id=$plantId');
    final response = await client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 404) {
      // If tags not found for plant id, 404 will be thrown
      throw CustomHttpException('404 Not Found', uri: response.request?.url ?? uri);
    } else if (response.statusCode != 200) {
      throw HttpException('Failed to load plant tags', uri: uri);
    }

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);

        return data.map<PlantTags>((json) => PlantTags.fromJson(json)).toList();
      } on FormatException catch (e) {
        print('The response was not JSON. $e');

        throw Exception('Failed to decode JSON data: $e');
      }
    } else { //explore if this code is reachable
      print('Request failed with status: ${response.statusCode}.');

      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> createPlantsTagApi(Map<String, dynamic> plantTagData) async {
    final uri = Uri.parse(apiUrl + 'plantstag');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final body = json.encode(plantTagData);

    final response = await client
        .post(uri, headers: headers, body: body)
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 201) {
      throw HttpException('Failed to create plant tag', uri: uri);
    }
  }
}
