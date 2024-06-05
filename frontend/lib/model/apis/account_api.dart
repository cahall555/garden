import 'dart:convert';
import 'package:http/http.dart' as http;
import '../account.dart';
import 'custom_exception.dart';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<List<Account>> fetchAccountApi(String id) async {
  final uri = Uri.parse(apiUrl + 'accounts/$id');
  final response = await http.get(uri).timeout(const Duration(seconds: 30));

  if (response.statusCode == 404) {
    return [];
    throw CustomHttpException('404 Not Found', uri: response.request!.url);
  } else if (response.statusCode != 200) {
    throw HttpException('Failed to load account', uri: uri);
  }

  final data = jsonDecode(response.body);

  if (data is Map) {
    return [Account.fromJson(Map<String, dynamic>.from(data))];
  } else if (data is List) {
    return data
        .map<Account>(
            (json) => Account.fromJson(Map<String, dynamic>.from(json)))
        .toList();
  } else {
    throw Exception('Expected a list or a map but got ${data.runtimeType}');
  }
}

Future<Account> createAccountApi(Map<String, dynamic> accountData) async {
  final url = Uri.parse(apiUrl + 'accounts');
  final headers = {"Content-Type": "application/json"};
  print('Account Data: $accountData');
  try {
    final response =
        await http.post(url, headers: headers, body: json.encode(accountData));

    if (response.statusCode == 201) {
      print('Account created successfully');
      return Account.fromJson(json.decode(response.body));
    } else {
      print('Failed to create account: ${response.body}');
      throw Exception('Failed to create account');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Error creating account: ${e.toString()}');
  }
}

Future<void> deleteAccountApi(String id) async {
  final url = Uri.parse(apiUrl + 'accounts/$id');
  final headers = {"Content-Type": "application/json"};

  final response = await http.delete(url, headers: headers);

  if (response.statusCode == 200) {
    print('Account deleted successfully');
  } else {
    print('Failed to delete account: ${response.body}');
    throw Exception('Failed to delete account');
  }
}
