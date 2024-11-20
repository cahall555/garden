import 'dart:convert';
import 'package:http/http.dart' as http;
import '../user.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final storage = const FlutterSecureStorage();
final String apiUrl = dotenv.env['API_URL']!;

class AuthApiService {
  final http.Client client;
  final FlutterSecureStorage storage;
  AuthApiService(this.client, this.storage);

  Future<User> createAuthApi(Map<String, dynamic> userData) async {
    final url = Uri.parse(apiUrl + 'auth');
    final headers = {"Content-Type": "application/json"};

    try {
      final response =
          await client.post(url, headers: headers, body: json.encode(userData));
      print(response.body);
      if (response.statusCode == 200 && response.body != null) {
        final responseBody = json.decode(response.body) as Map<String, dynamic>;
        final String? accessToken = responseBody['access_token'] as String?;
        final String? refreshToken = responseBody['refresh_token'] as String?;

        if (accessToken == null || refreshToken == null) {
          throw Exception('Tokens are missing in the response');
        }
        print('accessToken: $accessToken');
        await storage.write(key: 'accessToken', value: accessToken);
        await storage.write(key: 'refreshToken', value: refreshToken);

        final userJson = responseBody['user'] as Map<String, dynamic>?;
        if (userJson == null) {
          throw Exception('User object is missing in the response');
        }
        final User user = User.fromJson(userJson);
        return user;

      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized: Invalid credentials');
      } else if (response.statusCode == 500) {
        throw Exception('Server error: Please try again later');
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
    final accessToken = await _getAccessToken();

    try {
      final response = await client.delete(url,
          headers: {...headers, 'Authorization': 'Bearer $accessToken'});
      if (response.statusCode == 200) {
        await storage.deleteAll();
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

  Future<String?> _getAccessToken() async {
    final accessToken = await storage.read(key: 'accessToken');

    if (_isTokenExpired(accessToken)) {
      return await _refreshAccessToken();
    }

    return accessToken;
  }

  Future<String?> _refreshAccessToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    if (refreshToken == null) throw Exception('No refresh token found');

    final url = Uri.parse(apiUrl + 'auth/refresh');
    final headers = {"Content-Type": "application/json"};

    final response = await client.post(url,
        headers: headers, body: json.encode({'refreshToken': refreshToken}));

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      final newAccessToken = responseBody['accessToken'];
      await storage.write(key: 'accessToken', value: newAccessToken);
      return newAccessToken;
    } else if (response.statusCode == 401) {
      await logoutApi();
      throw Exception('Session expired. Please log in again.');
    } else {
      throw Exception('Failed to refresh token: ${response.body}');
    }
  }

  bool _isTokenExpired(String? token) {
    if (token == null) return true;
    try {
      final payload = json.decode(utf8
          .decode(base64Url.decode(base64Url.normalize(token.split('.')[1]))));
      final expiry = DateTime.fromMillisecondsSinceEpoch(payload['exp'] * 1000);
      return DateTime.now().isAfter(expiry);
    } catch (e) {
      print('Error decoding token: $e');
      return true;
    }
  }
}
