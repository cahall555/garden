import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/user_api.dart';

class UserProvider with ChangeNotifier {
  User? newUser;
  final userApiService;
  UserProvider(this.userApiService);

  Future<User> createUser(Map<String, dynamic> user) async {
    try {
      newUser = await userApiService.createUserApi(user);
      notifyListeners();
      print('provider user: $newUser');
      return newUser!;
    } catch (e) {
      print(e);
      throw Exception('Error creating user: ${e.toString()}');
    }
  }
}
