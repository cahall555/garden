import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/garden.dart';

class GardenRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertGarden(Garden garden) async {
    final db = await dbHelper.database;
    await db.insert('Garden', garden.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Garden>> fetchAllGardens(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Garden',
        where: 'account_id = ?',
        whereArgs: [accountId]);
    return List.generate(maps.length, (i) => Garden.fromJson(maps[i]));
  }

  Future<List<Garden>> fetchCurrentGardens(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Garden',
        where: 'account_id = ? AND marked_for_deletion = 0',
        whereArgs: [accountId]);
    return List.generate(maps.length, (i) => Garden.fromJson(maps[i]));
  }


  Future<void> updateGarden(Garden garden, var id) async {
    final db = await dbHelper.database;
    await db.update(
      'Garden',
      garden.toJson(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteGarden(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'Garden',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markForDeletion(var id) async {
    final db = await dbHelper.database;
    await db.update(
      'Garden',
      {'marked_for_deletion': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
