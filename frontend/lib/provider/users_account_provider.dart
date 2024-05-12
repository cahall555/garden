import 'package:flutter/widgets.dart';
import '../model/users_account.dart';
import '../model/apis/users_account_api.dart';

class UsersAccountsProvider with ChangeNotifier {
  List<UserAccounts> ua = [];
 
  Future<List<UserAccounts>> fetchUserAccounts(var accountId) async {
    try {
      ua = await fetchUserAccountsApi(accountId);
      notifyListeners();
      return ua;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> createUserAccounts(Map<String, dynamic> userAccount) async {
    try {
      await createUserAccountsApi(userAccount);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
