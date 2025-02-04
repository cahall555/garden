import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/plants_tag.dart';

class PlantsTagRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertPlantsTag(PlantTags plantTags) async {
    final db = await dbHelper.database;
    await db.insert('PlantTags', plantTags.toJson(),
	conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<PlantTags>> fetchAllPlantTags(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PlantTags' , where: 'plant_id = ?', whereArgs: [plantId]);
    return List.generate(maps.length, (i) => PlantTags.fromJson(maps[i]));
  }

 Future<List<PlantTags>> fetchCurrentPlantTags(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PlantTags' , where: 'plant_id = ? AND marked_for_deletion = 0', whereArgs: [plantId]);
    return List.generate(maps.length, (i) => PlantTags.fromJson(maps[i]));
  }


 Future<List<PlantTags>> fetchAllPlantTagsAccount(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PlantTags' , where: 'account_id = ?', whereArgs: [accountId]);
    return List.generate(maps.length, (i) => PlantTags.fromJson(maps[i]));
  }

 Future<List<PlantTags>> fetchCurrentPlantTagsAccount(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PlantTags' , where: 'account_id = ? AND marked_for_deletion = 0', whereArgs: [accountId]);
    return List.generate(maps.length, (i) => PlantTags.fromJson(maps[i]));
  }

 Future<PlantTags> fetchPlantTag(var plantId, var tagId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('PlantTags' , where: 'plant_id = ? AND tag_id = ?', whereArgs: [plantId, tagId]);
    return PlantTags.fromJson(maps[0]);
  }

  Future<void> deletePlantTag(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'PlantTags',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> markForDeletion(var id) async {
    final db = await dbHelper.database;
    await db.update(
      'PlantTags',
      {'marked_for_deletion': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}


