import 'package:flutter/widgets.dart';
import '../model/users_account.dart';
import '../model/apis/users_account_api.dart';

class UsersAccountsProvider with ChangeNotifier {
  List<UserAccounts> ua = [];
  UserAccounts? userAccount;
  final usersAccountApiService;
  UsersAccountsProvider(this.usersAccountApiService);

 
  Future<List<UserAccounts>> fetchUserAccounts(var accountId) async {
    try {
      ua = await usersAccountApiService.fetchUserAccountsApi(accountId);
      notifyListeners();
      return ua;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<UserAccounts> fetchUserAccount(var userId) async {
    try {
      userAccount = await usersAccountApiService.fetchUserAccountApi(userId);
      notifyListeners();
      return userAccount!;
    } catch (e) {
      print(e);
      throw Exception('Error locating user account: ${e.toString()}');

    }
  }

  Future<UserAccounts> createUserAccounts(Map<String, dynamic> userAccountData) async {
    try {
      userAccount = await usersAccountApiService.createUserAccountsApi(userAccountData);
      notifyListeners();
      return userAccount!;
    } catch (e) {
      print(e);
      throw Exception('Error creating user account: ${e.toString()}');
    }
  }
}
