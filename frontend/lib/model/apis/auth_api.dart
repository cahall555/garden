import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

Future<User> createAuthApi(Map<String, dynamic> userData) async {
  final url = Uri.parse(apiUrl + 'auth');
  print('3) url: $url');
  final headers = {"Content-Type": "application/json"};

  try {
    print('4) sending createAuthApi: $userData');
    final response =
        await http.post(url, headers: headers, body: json.encode(userData));
	return User.fromJson(json.decode(response.body));

    print('5) response: ${response.statusCode}');
    if (response.statusCode == 200) {
      print('Login successful');
    } else {
      print('6) Failed to login: ${response.body}');
      throw Exception('7) Failed to login');
    }
  } catch (e) {
    print(e.toString());
    throw Exception('8) Error authenticating user: ${e.toString()}');
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
