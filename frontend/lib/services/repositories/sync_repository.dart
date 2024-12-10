import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/sync_log.dart';

class SyncLogRepository {
  final dbHelper = DatabaseHelper();

  Future<void> saveSyncLog(SyncLog log) async {
    final db = await dbHelper.database;
    await db.insert(
      'SyncLog',
      log.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<SyncLog?> getSyncLog(String entity) async {
    final db = await dbHelper.database;

    final result = await db.query(
      'SyncLog',
      where: 'entity = ?',
      whereArgs: [entity],
    );
    if (result.isNotEmpty) {
      return SyncLog.fromJson(result.first);
    }
    return null;
  }
}
