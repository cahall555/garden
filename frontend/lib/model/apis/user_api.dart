import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String apiUrl = dotenv.env['API_URL']!;

class UserApiService {
  final http.Client client;
  UserApiService(this.client);

  Future<User> createUserApi(Map<String, dynamic> userData) async {
    final url = Uri.parse(apiUrl + 'users');
    final headers = {"Content-Type": "application/json"};
    print('User Data: $userData');

    try {
      final response =
          await client.post(url, headers: headers, body: json.encode(userData));
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        print('User created successfully');
        return User.fromJson(json.decode(response.body));
      } else {
        print('Failed to create user: ${response.body}');
        throw Exception('Failed to create user');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('Error creating user: ${e.toString()}');
    }
  }
}
