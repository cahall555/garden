import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';

class AuthProvider with ChangeNotifier {

  Future<void> createAuth(Map<String, dynamic> user) async {
    createAuthApi(user);
    notifyListeners();
  }

