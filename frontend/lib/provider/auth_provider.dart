import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';

class AuthProvider with ChangeNotifier {

  User? _user;

  AuthProvider([this._user]);

  String get email => _user?.email ?? '';

  String get FirstName => _user?.firstName ?? '';


  Future<void> createAuth(Map<String, dynamic> user) async {
    createAuthApi(user);
    notifyListeners();
  }


  Future<void> login(Map<String, dynamic> credentials) async {
    _user = User.fromJson(credentials);
    await createAuthApi(credentials);
    notifyListeners();
  }


  bool get isLoggedIn => _user != null;
}
