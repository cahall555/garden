import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';

class AuthProvider with ChangeNotifier {
  User? authUser;

  AuthProvider([this.authUser]);

  String get email => authUser?.email ?? '';

  String get FirstName => authUser?.firstName ?? '';

  Future<User> createAuth(Map<String, dynamic> user) async {
    try {
      print('2) createAuth (provider): $user');
      authUser = await createAuthApi(user);
      notifyListeners();
      return authUser!;
    } catch (e) {
      print(e);
      throw Exception('Error authenticating user: ${e.toString()}');
    }
  }

  Future<void> login(Map<String, dynamic> credentials) async {
    authUser = User.fromJson(credentials);
    await createAuthApi(credentials);
    notifyListeners();
  }

  Future<void> logout() async {
    await logoutApi();
    notifyListeners();
  }
  

  bool get isLoggedIn => authUser != null;
}
