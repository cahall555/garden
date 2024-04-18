import 'dart:convert';
import 'package:http/http.dart' as http;
import '../journal.dart';
import 'dart:io';

Future<List<Journal>> fetchJournalApi() async {
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

Future<List<Journal>> fetchPlantJournalApi(var plantId) async {
  final response = await http
      .get(Uri.parse('http://localhost:3000/plant_journals?plant_id=$plantId'));

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

//Future<void> createJournalApi(Map<String, dynamic> journalData, var plantId) async {
//  	final url = Uri.parse('http://localhost:3000/journals?plantId=$plantId');
//  	final headers = {"Content-Type": "application/json"};
//
//	try{
//  		final response = await http.post(url, headers: headers, body: json.encode(journalData));
//
//  		if (response.statusCode == 201) {
//    			print('Journal created successfully');
//  		} else {
//    			print('Failed to create journal: ${response.body}');
//    			throw Exception('Failed to create journal');
//  		}
//	} catch (e) {
//		print(e.toString());
//	}
//}

Future<void> createJournalApi(
    Map<String, dynamic> journalData, String plantId, String? filePath) async {
  final url = Uri.parse('http://localhost:3000/journals?plantId=$plantId');
  var request = http.MultipartRequest('POST', url);
  request.fields['title'] = journalData['title'];
  request.fields['entry'] = journalData['entry'];
  request.fields['category'] = journalData['category'];
  request.fields['plant_id'] = journalData['plant_id'];
  request.fields['display_in_garden'] = journalData['display_in_garden'].toString();

  if (filePath != null && filePath.isNotEmpty) {
    request.files
        .add(await http.MultipartFile.fromPath('_imagePath', filePath));
  }
  try {
    var streamedResponse = await request.send();

    if (streamedResponse.statusCode == 201) {
      print('Journal created successfully');
    } else {
      print(
          'Failed to create journal: Status code ${streamedResponse.statusCode}');
      streamedResponse.stream.transform(utf8.decoder).listen((value) {
        print(value);
      });
      throw Exception('Failed to create journal');
    }
  } catch (e) {
    print('Exception caught: $e');
  }
}
