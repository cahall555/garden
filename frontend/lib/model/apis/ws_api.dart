import 'dart:convert';
import 'package:http/http.dart' as http;
import '../ws.dart';
import 'custom_exception.dart';
import 'dart:io'; 

Future<List<WaterSchedule>> fetchWaterSchedule(String plantId) async {
  final uri = Uri.parse('http://localhost:3000/water_schedules?plant_id=$plantId');
  final response = await http.get(uri).timeout(const Duration(seconds: 10));

  if (response.statusCode == 404) {
    // If plant id does not have a water schedule, 404 will be thrown
    throw CustomHttpException('404 Not Found', uri: response.request!.url);
  } else if (response.statusCode != 200) {
    
    throw HttpException('Failed to load water schedule', uri: uri);
  }

  
  final data = jsonDecode(response.body);

  
  if (data is Map) {
    return [WaterSchedule.fromJson(Map<String, dynamic>.from(data))];
  } else if (data is List) {
    return data.map<WaterSchedule>((json) => WaterSchedule.fromJson(Map<String, dynamic>.from(json))).toList();
  } else {
    
    throw Exception('Expected a list or a map but got ${data.runtimeType}');
  }
}

