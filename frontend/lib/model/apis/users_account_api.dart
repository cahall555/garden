import 'dart:convert';
import 'package:http/http.dart' as http;
import '../users_account.dart';
import 'custom_exception.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class UsersAccountApiService {
  final http.Client client;
  UsersAccountApiService(this.client);

  Future<List<UserAccounts>> fetchUserAccountsApi(var accountId) async {
    final uri = Uri.parse(apiUrl + 'useraccounts?account_id=$accountId');
    final response = await client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 404) {
      // If tags not found for plant id, 404 will be thrown
      throw CustomHttpException('404 Not Found', uri: response.request!.url);
    } else if (response.statusCode != 200) {
      throw HttpException('Failed to load user accounts', uri: uri);
    }

    if (response.statusCode == 200) {
      try {
        final List<dynamic> data = json.decode(response.body);

        return data
            .map<UserAccounts>((json) => UserAccounts.fromJson(json))
            .toList();
      } on FormatException catch (e) {
        print('The response was not JSON. $e');

        throw Exception('Failed to decode JSON data: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');

      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<UserAccounts> fetchUserAccountApi(var userId) async {
    final uri = Uri.parse(apiUrl + 'usersaccount?user_id=$userId');
    final response = await client.get(uri).timeout(const Duration(seconds: 30));

    if (response.statusCode == 404) {
      throw CustomHttpException('404 Not Found', uri: response.request!.url);
    } else if (response.statusCode != 200) {
      throw HttpException('Failed to load user account', uri: uri);
    }

    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = json.decode(response.body);

        return UserAccounts.fromJson(data);
      } on FormatException catch (e) {
        print('The response was not JSON. $e');

        throw Exception('Failed to decode JSON data: $e');
      }
    } else {
      print('Request failed with status: ${response.statusCode}.');

      throw Exception('Request failed with status: ${response.statusCode}.');
    }
  }

  Future<UserAccounts> createUserAccountsApi(
      Map<String, dynamic> userAccountData) async {
    final uri = Uri.parse(apiUrl + 'usersaccount');
    print('User Account Data: $userAccountData');
    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    final body = json.encode(userAccountData);
    try {
      final response = await client
          .post(uri, headers: headers, body: body)
          .timeout(const Duration(seconds: 30));
      if (response.statusCode == 201) {
        print('User account created successfully');
        return UserAccounts.fromJson(json.decode(response.body));
      } else {
        print('Failed to create user account: ${response.body}');
        throw Exception('Failed to create user account');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error creating user account: ${e.toString()}');
    }
  }
}
