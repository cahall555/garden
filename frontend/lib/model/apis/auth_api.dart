import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<void> createAuthApi(Map<String, dynamic> userData) async {
  final url = Uri.parse(apiUrl + 'auth');
  final headers = {"Content-Type": "application/json"};

  try {
    print('sending createAuthApi: $userData');
    final response =
        await http.post(url, headers: headers, body: json.encode(userData));
    print('response: ${response.body}');
    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      print('Failed to login: ${response.body}');
      throw Exception('Failed to login');
    }
  } catch (e) {
    print(e.toString());
  }
}
