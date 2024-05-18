import 'package:flutter/widgets.dart';
import '../model/account.dart';
import '../model/apis/account_api.dart';

class AccountProvider with ChangeNotifier {
  Account? newAccount;


  Future<Account> createAccount(
    Map<String, dynamic> account,
  ) async {
    newAccount = await createAccountApi(account);
    notifyListeners();
    print('provider account: $newAccount');
    return newAccount!;
  }

  Future<void> deleteAccount(var id) async {
    await deleteAccountApi(id);
    notifyListeners();
  }
}
