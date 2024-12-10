import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/user.dart';
import 'package:frontend/model/account.dart';
import 'package:frontend/model/users_account.dart';

class UserAccountRepository {
  final dbHelper = DatabaseHelper();

  Future<void> saveCurrentUser(User user) async {
    final db = await dbHelper.database;

    await db.insert('User', user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> saveCurrentAccount(Account account) async {
    final db = await dbHelper.database;
    await db.insert('Account', account.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<User?> getCurrentUser() async {
    final db = await dbHelper.database;
    final result = await db.query('User', limit: 1);
    return result.isNotEmpty ? User.fromJson(result.first) : null;
  }

//Future growth, a user may be a part of more than one account
  Future<Account?> getCurrentAccount() async {
    final db = await dbHelper.database;
    final result = await db.query('Account', limit: 1);
    return result.isNotEmpty ? Account.fromJson(result.first) : null;
  }

  Future<void> clearCurrentUser() async {
    final db = await DatabaseHelper().database;
    await db.delete('User');
    await db.delete('Account');
  }
}
