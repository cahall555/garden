import 'dart:convert';
import 'package:http/http.dart' as http;
import '../farm.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future <List<Farm>> fetchFarmApi(String id) async {
  final response = await http.get(Uri.parse(apiUrl + 'farms/${id}'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<Farm>((json) => Farm.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future <List<Farm>> fetchFarmsApi(String accountId) async {
  final response = await http.get(Uri.parse(apiUrl + 'farms?account_id=$accountId'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);
      return data.map<Farm>((json) => Farm.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> createFarmApi(Map<String, dynamic> farmData, var accountId) async {
  	final url = Uri.parse(apiUrl + 'farms?accountId=$accountId');
  	final headers = {"Content-Type": "application/json"};
	 
	try{
  		final response = await http.post(url, headers: headers, body: json.encode(farmData));

  		if (response.statusCode == 201) {
    			print('Farm created successfully');
  		} else {
    			print('Failed to create farm: ${response.body}');
    			throw Exception('Failed to create farm');
  		}
	} catch (e) {
		print(e.toString());
	}
}

Future<List<Farm>> updateFarmApi(Map<String, dynamic> farmData, var farmId) async {
  final url = Uri.parse(apiUrl + 'farms/$farmId');
  final headers = {"Content-Type": "application/json"};

  final response = await http.put(url, headers: headers, body: jsonEncode(farmData));

  if (response.statusCode == 201) {
    try {
	final Map<String, dynamic> data = json.decode(response.body);
	return [Farm.fromJson(data)];
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> deleteFarmApi(var farmId) async {
	final url = Uri.parse(apiUrl + 'farms/$farmId');
	final headers = {"Content-Type": "application/json"};

	final response = await http.delete(url, headers: headers);

	if (response.statusCode == 200) {
		print('Farm deleted successfully');
	} else {
		print('Failed to delete farm: ${response.body}');
		throw Exception('Failed to delete farm');
	}
}
