import 'package:flutter/widgets.dart';
import '../model/account.dart';
import '../model/apis/account_api.dart';

class AccountProvider with ChangeNotifier {
  
   Future<Account> createAccount(
    Map<String, dynamic> account,
  ) async {
    createAccountApi(account);
    notifyListeners();
    return Account.fromJson(account);
  }

  Future<void> deleteAccount(var id) async {
    await deleteAccountApi(id);
    notifyListeners();
  }
}
