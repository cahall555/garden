import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CsrfTokenProvider {
  String _csrfToken = '';

  Future<void> fetchCsrfToken() async {
    final response = await http.get(Uri.parse('http://localhost:3000/csrf'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print('data from token fetch: $data');
      _csrfToken = data['csrf_token'];
    } else {
      throw Exception('Failed to fetch CSRF token');
    }
  }

  String get csrfToken => _csrfToken;
}

