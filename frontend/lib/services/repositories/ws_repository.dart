import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/ws.dart';

class WaterScheduleRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertWaterSchedule(WaterSchedule waterSchedule) async {
    final db = await dbHelper.database;
    await db.insert('WaterSchedule', waterSchedule.toJson(forSqlLite: true),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<WaterSchedule>> fetchAllWaterSchedules(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('WaterSchedule',
	where: 'plant_id = ?', whereArgs: [plantId]);
    return List.generate(maps.length, (i) => WaterSchedule.fromJson(maps[i]));
  }

  Future<List<WaterSchedule>> fetchCurrentWaterSchedules(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('WaterSchedule',
	where: 'plant_id = ? AND marked_for_deletion = 0', whereArgs: [plantId]);
    return List.generate(maps.length, (i) => WaterSchedule.fromJson(maps[i]));
  }

  Future<void> updateWaterSchedule(WaterSchedule waterSchedule) async {
    final db = await dbHelper.database;
    await db.update(
      'WaterSchedule',
      waterSchedule.toJson(forSqlLite: true),
      where: 'id = ?',
      whereArgs: [waterSchedule.id],
    );
  }

  Future<void> deleteWaterSchedule(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'WaterSchedule',
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
