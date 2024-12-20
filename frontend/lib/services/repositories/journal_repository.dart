import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/journal.dart';

class JournalRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertJournal(Journal journal) async {
    final db = await dbHelper.database;
    print(journal.toJson(forSqlLite: true));
    await db.insert('Journal', journal.toJson(forSqlLite: true),
	conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Journal>> fetchJournals() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Journal',
	orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Journal.fromJson(maps[i]));
  }

  Future<List<Journal>> fetchAllJournals(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Journal',
	where: 'plant_id = ?',
	whereArgs: [plantId],
	orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Journal.fromJson(maps[i]));
  }

  Future<List<Journal>> fetchCurrentJournals(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Journal',
	where: 'plant_id = ? AND marked_for_deletion = 0',
	whereArgs: [plantId],
	orderBy: 'created_at DESC');
    return List.generate(maps.length, (i) => Journal.fromJson(maps[i]));
  }

  Future<void> updateJournal(Journal journal) async {
    final db = await dbHelper.database;
    await db.update(
      'Journal',
      journal.toJson(forSqlLite: true),
      where: 'id = ?',
      whereArgs: [journal.id],
    );
  }

  Future<void> deleteJournal(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'Journal',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> markForDeletion(var id) async {
    final db = await dbHelper.database;
    await db.update(
      'Journal',
      {'marked_for_deletion': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}