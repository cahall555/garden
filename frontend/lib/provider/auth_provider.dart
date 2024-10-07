import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/auth_api.dart';

class AuthProvider with ChangeNotifier {
  User? authUser;
  final authApiService;
  AuthProvider({this.authUser, required this.authApiService});

  String get email => authUser?.email ?? '';

  String get FirstName => authUser?.firstName ?? '';

  Future<User> createAuth(Map<String, dynamic> user) async {
    try {
      print('2) createAuth (provider): $user');
      authUser = await authApiService.createAuthApi(user);
      notifyListeners();
      return authUser!;
    } catch (e) {
      print(e);
      throw Exception('Error authenticating user: ${e.toString()}');
    }
  }

  Future<void> login(Map<String, dynamic> credentials) async {
    authUser = User.fromJson(credentials);
    await authApiService.createAuthApi(credentials);
    notifyListeners();
  }

  Future<void> logout() async {
    await authApiService.logoutApi();
    notifyListeners();
  }
  

  bool get isLoggedIn => authUser != null;
}
