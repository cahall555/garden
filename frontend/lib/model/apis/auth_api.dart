import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<void> createAuthApi(Map<String, dynamic> userData) async {
  final url = Uri.parse(apiUrl + 'auth');
  print('3) url: $url');
  final headers = {"Content-Type": "application/json"};

  try {
    print('4) sending createAuthApi: $userData');
    final response =
        await http.post(url, headers: headers, body: json.encode(userData));
    print('5) response: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      print('6) Failed to login: ${response.body}');
      throw Exception('7) Failed to login');
    }
  } catch (e) {
    print(e.toString());
  }
}
