import 'dart:convert';
import 'package:http/http.dart' as http;
import '../journal.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class JournalApiService {
  final http.Client client;
  JournalApiService(this.client);

  Future<List<Journal>> fetchJournalApi() async {
    final response = await client.get(Uri.parse(apiUrl + 'journals'));

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
    final response =
        await client.get(Uri.parse(apiUrl + 'plant_journals?plant_id=$plantId'));

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

  Future<void> createJournalApi(Map<String, dynamic> journalData,
      String plantId, String? filePath) async {
    final url = Uri.parse(apiUrl + 'journals?plantId=$plantId');
    var request = http.MultipartRequest('POST', url);
    request.fields['title'] = journalData['title'];
    request.fields['entry'] = journalData['entry'];
    request.fields['category'] = journalData['category'];
    request.fields['plant_id'] = journalData['plant_id'];
    request.fields['display_in_garden'] =
        journalData['display_in_garden'].toString();

    if (filePath != null && filePath.isNotEmpty) {
      request.files
          .add(await http.MultipartFile.fromPath('_imagePath', filePath));
    }
    try {
      var streamedResponse = await client.send(request);

      if (streamedResponse.statusCode == 200) {
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

  Future<void> updateJournalApi(Map<String, dynamic> journalData, var journalId,
      var plantId, String? filePath) async {
    final url = Uri.parse(apiUrl + 'journals?id=$journalId&plantId=$plantId');
    var request = http.MultipartRequest('PUT', url);
    request.headers['user-agent'] = 'Dart/3.4 (dart:io)';
    request.headers['accept-encoding'] = 'gzip';
    request.headers['content-type'] =
        'multipart/form-data; boundary=dart-http-boundary-0mQ9TnOjRDhESqXu9gbeagMUphbJ+xU5vQZIEG7OrM-+OHq2x95';

    request.fields['id'] = journalData['id'];
    request.fields['title'] = journalData['title'];
    request.fields['entry'] = journalData['entry'];
    request.fields['category'] = journalData['category'];
    request.fields['plant_id'] = journalData['plant_id'];
    request.fields['display_in_garden'] =
        journalData['display_in_garden'].toString();

    print('***filePath in journal api***');
    print(filePath);
    if (filePath != null && filePath.isNotEmpty) {
      try {
        final file = File(filePath);
        if (await file.exists()) {
          request.files
              .add(await http.MultipartFile.fromPath('_imagePath', filePath));
        } else {
          print('File does not exist at the specified path: $filePath');
	  throw Exception('File does not exist at the specified path: $filePath');
        }
      } catch (e) {
        print('Error checking file existence: $e');
	throw Exception('Error checking file existence: $e');
      }
    }

    print('***request in journal api***');
    print(request);
    try {
      var streamedResponse = await client.send(request);
      final responseBody = await streamedResponse.stream.bytesToString();
      print('Response Body: $responseBody');
      if (streamedResponse.statusCode == 200) {
        print('Journal updated successfully');
      } else {
        print(
            'Failed to update journal: Status code ${streamedResponse.statusCode}');
        streamedResponse.stream.transform(utf8.decoder).listen((value) {
          print(value);
        });
        final responseBody = await streamedResponse.stream.bytesToString();
        print('Response Body: $responseBody');

        throw Exception('Failed to update journal');
      }
    } catch (e) {
      print('Exception caught: $e');
    }
    print('End of updateJournalApi');
  }

  Future<void> deleteJournalApi(var journalId) async {
    final url = Uri.parse(apiUrl + 'journals/$journalId?id=$journalId');
    final response = await client.delete(url);

    if (response.statusCode == 200) {
      print('Journal deleted successfully');
    } else {
      print('Failed to delete journal: Status code ${response.statusCode}');
      throw Exception('Failed to delete journal');
    }
  }
}
