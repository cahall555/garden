import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ws.dart';
import 'custom_exception.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class WsApiService {
  final http.Client client;
  WsApiService(this.client);

  Future<List<WaterSchedule>> fetchWsApi(String plantId) async {
    final uri = Uri.parse(apiUrl + 'water_schedules?plant_id=$plantId');
    final response = await client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 404) {
      return [];
      // If plant id does not have a water schedule, 404 will be thrown
      throw CustomHttpException('404 Not Found', uri: response.request!.url);
    } else if (response.statusCode != 200) {
      throw HttpException('Failed to load water schedule', uri: uri);
    }

    final data = jsonDecode(response.body);

    if (data is Map) {
      return [WaterSchedule.fromJson(Map<String, dynamic>.from(data))];
    } else if (data is List) {
      return data
          .map<WaterSchedule>(
              (json) => WaterSchedule.fromJson(Map<String, dynamic>.from(json)))
          .toList();
    } else {
      throw Exception('Expected a list or a map but got ${data.runtimeType}');
    }
  }

  Future<void> createWsApi(Map<String, dynamic> wsData, var plantId) async {
    final url = Uri.parse(apiUrl + 'water_schedules?plantId=$plantId');
    final headers = {"Content-Type": "application/json"};

    try {
      final response =
          await client.post(url, headers: headers, body: json.encode(wsData));

      if (response.statusCode == 201) {
        print('Water schedule created successfully');
      } else {
        print('Failed to create water schedule: ${response.body}');
        throw Exception('Failed to create water schedule');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<List<WaterSchedule>> updateWsApi(
      Map<String, dynamic> wsData, var plantId, var wsId) async {
    final url =
        Uri.parse(apiUrl + 'water_schedules?plantId=$plantId&wsId=$wsId');
    final headers = {"Content-Type": "application/json"};

    final response =
        await client.put(url, headers: headers, body: jsonEncode(wsData));

    if (response.statusCode == 201) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);
        return [WaterSchedule.fromJson(data)];
      } on FormatException catch (e) {
        print('The response was not JSON. $e');

        throw Exception('Failed to decode JSON data: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');

      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<void> deleteWsApi(var wsId) async {
    final url = Uri.parse(apiUrl + 'water_schedules/$wsId');
    final headers = {"content-Type": "application/json"};

    final response =
        await client.delete(url, headers: headers); //, body: jsonEncode());
  }
}
