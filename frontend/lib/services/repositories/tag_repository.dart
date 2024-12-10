import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/tag.dart';

class TagRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertTag(Tag tag) async {
    final db = await dbHelper.database;
    await db.insert('Tag', tag.toJson(),
	conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Tag>> fetchAllTags(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Tag' , where: 'account_id = ?', whereArgs: [accountId]);
    return List.generate(maps.length, (i) => Tag.fromJson(maps[i]));
  }

  Future<void> updateTag(Tag tag) async {
    final db = await dbHelper.database;
    await db.update(
      'Tag',
      tag.toJson(),
      where: 'id = ?',
      whereArgs: [tag.id],
    );
  }

  Future<void> deleteTag(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'Tag',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}


