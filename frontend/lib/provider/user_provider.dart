import 'package:flutter/widgets.dart';
import '../model/user.dart';
import '../model/apis/user_api.dart';
import 'package:frontend/services/repositories/user_account_repository.dart';
import 'package:frontend/services/connection_status.dart';

class UserProvider with ChangeNotifier {
  User? newUser;
  final userApiService;
  final UserAccountRepository userAccountRepository;

  UserProvider(this.userApiService, this.userAccountRepository);

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

  Future<void> syncWithBackend(var userId) async {
    if (await isOnline()) {
      try {
        final userFromBackend =
            await userApiService.fetchUsertApi(userId);
        for (var user in userFromBackend) {
          await userAccountRepository.saveCurrentUser(user);
        }
       newUser = await userAccountRepository.getCurrentUser();
        notifyListeners();
      } catch (e) {
        print('Error syncing with backend: $e');
      }
    } else {
      print('Offline: Sync skipped');
    }
  }

  Future<bool> isOnline() async {
 //  return await ConnectionStatusSingleton.getInstance().checkConnection();
	  return true;
  }

}
