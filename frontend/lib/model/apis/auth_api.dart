import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

future<void> createAuthApi(Map<String, dynamic> userData) async {
  final url = Uri.parse(apiUrl + 'auth');
  final headers = {"Content-Type": "application/json"};

  try {
    final response = await http.post(url, headers: headers, body: json.encode(userData));

    if (response.statusCode == 201) {
      print('User created successfully');
    } else {
      print('Failed to create user: ${response.body}');
      throw Exception('Failed to create user');
    }
  } catch (e) {
    print(e.toString());
  }
}
