import 'dart:convert';
import 'package:http/http.dart' as http;
import '../users_account.dart';
import 'custom_exception.dart';
import 'dart:io'; 
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<List<UserAccounts>> fetchUserAccountsApi(var userId) async {
  final uri = Uri.parse(apiUrl + 'useraccounts?user_id=$userId');
  final response = await http.get(uri).timeout(const Duration(seconds: 30));

  if (response.statusCode == 404) {
    // If tags not found for plant id, 404 will be thrown
    throw CustomHttpException('404 Not Found', uri: response.request!.url);
  } else if (response.statusCode != 200) {
    
    throw HttpException('Failed to load user accounts', uri: uri);
  }

  if (response.statusCode == 200) {
    try {
      final List<dynamic> data = json.decode(response.body);

      return data.map<UserAccounts>((json) => UserAccounts.fromJson(json)).toList();
    } on FormatException catch (e) {
      print('The response was not JSON. $e');
      
      throw Exception('Failed to decode JSON data: $e');
    }
  } else {
    print('Request failed with status: ${response.statusCode}.');

    throw Exception('Request failed with status: ${response.statusCode}.');
  }
}

Future<void> createUserAccountsApi(Map<String, dynamic> userAccountData) async {
  final uri = Uri.parse(apiUrl + 'useraccounts');
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  final body = json.encode(userAccountData);

  final response = await http.post(uri, headers: headers, body: body).timeout(const Duration(seconds: 30));

  if (response.statusCode != 201) {
    throw HttpException('Failed to create user account', uri: uri);
  }
}
