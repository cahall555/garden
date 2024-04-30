import 'dart:convert';
import 'package:http/http.dart' as http;
import '../garden.dart';
import 'csrf.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<List<Garden>> fetchGardenApi() async {
  final response = await http.get(Uri.parse(apiUrl + 'gardens/'));

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<Garden>((json) => Garden.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');
    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

/*CSRF commented out, may want to activate later, see comment in App.go line 14*/
//class GardenApi {
  //final CsrfTokenProvider csrfTokenProvider = CsrfTokenProvider();

 // Future<void> initCsrfToken() async {
  //  await csrfTokenProvider.fetchCsrfToken();
   // print('Fetched CSRF Token: ${csrfTokenProvider.csrfToken}');
  //}
	Future<void> createGardenApi(Map<String, dynamic> gardenData) async {
  		final url = Uri.parse(apiUrl + 'gardens');
  		final headers = {"Content-Type": "application/json"};//, "X-CSRF-Token": csrfTokenProvider.csrfToken};
		 //print('Using CSRF Token: ${csrfTokenProvider.csrfToken}');
		try{
  		final response = await http.post(url, headers: headers, body: json.encode(gardenData));

  		if (response.statusCode == 201) {
    			print('Garden created successfully');
  		} else {
    			print('Failed to create garden: ${response.body}');
    			throw Exception('Failed to create garden');
  		}
		} catch (e) {
			print(e.toString());
		}
	}
//}

Future<List<Garden>> updateGardenApi(Map<String, dynamic> gardenData, var gardenId) async {
  final url = Uri.parse(apiUrl +'gardens?gardenId=$gardenId');
  final headers = {"Content-Type": "application/json"};

  final response = await http.put(url, headers: headers, body: jsonEncode(gardenData));

  if (response.statusCode == 200) {
    try {
	final Map<String, dynamic> data = json.decode(response.body);
	return [Garden.fromJson(data)];
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> deleteGardenApi(var gardenId) async {
  final url = Uri.parse(apiUrl + 'gardens/$gardenId?id=$gardenId');
  final headers = {"Content-Type": "application/json"};

  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    print('Garden deleted successfully');
  } else {
    print('Failed to delete garden: ${response.body}');
    throw Exception('Failed to delete garden');
  }
}
