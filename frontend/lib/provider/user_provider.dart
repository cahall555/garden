import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/user_api.dart';

class UserProvider with ChangeNotifier {

  Future<void> createUser(Map<String, dynamic> user) async {
    createUserApi(user);
    notifyListeners();
  }
}
