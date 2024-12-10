import 'package:flutter/widgets.dart';
import '../model/account.dart';
import '../model/apis/account_api.dart';
import 'package:frontend/services/repositories/user_account_repository.dart';
import 'package:frontend/services/connection_status.dart';

class AccountProvider with ChangeNotifier {
  Account? newAccount;
  final accountApiService;
  final UserAccountRepository userAccountRepository;

  AccountProvider(this.accountApiService, this.userAccountRepository);

  Future<Account> currentAccountId() async {
    newAccount = await accountApiService.fetchCurrentAccountApi();
    notifyListeners();
    return newAccount!;
  }

  Future<Account> createAccount(
    Map<String, dynamic> account,
  ) async {
    newAccount = await accountApiService.createAccountApi(account);
    notifyListeners();
    print('provider account: $newAccount');
    return newAccount!;
  }

  Future<void> deleteAccount(var id) async {
    await accountApiService.deleteAccountApi(id);
    notifyListeners();
  }

  Future<void> syncWithBackend(var accountId) async {
    if (await isOnline()) {
      try {
        final accountFromBackend =
            await accountApiService.fetchAccountApi(accountId);
        for (var account in accountFromBackend) {
          await userAccountRepository.saveCurrentAccount(account);
        }
        newAccount = await userAccountRepository.getCurrentAccount();
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
