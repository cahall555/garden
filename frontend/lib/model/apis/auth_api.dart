import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<User> createAuthApi(Map<String, dynamic> userData) async {
  final url = Uri.parse(apiUrl + 'auth');
  final headers = {"Content-Type": "application/json"};

  try {
    final response =
        await http.post(url, headers: headers, body: json.encode(userData));

    if (response.statusCode == 200 && response.body != null) {
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to login: ${response.body}');
      throw Exception('Failed to create user');
    }
  } catch (e) {
    print('Error creating user: $e');
    throw Exception('Error creating user: $e');
  }
}

Future<void> logoutApi() async {
  final url = Uri.parse(apiUrl + 'auth/delete');
  final headers = {"Content-Type": "application/json"};

  try {
    final response = await http.delete(url, headers: headers);
    if (response.statusCode == 200) {
      print('Logout successful');
    } else {
      print('Failed to logout: ${response.body}');
      throw Exception('Failed to logout');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('Error logging out: ${e.toString()}');
  }
}
