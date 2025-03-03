import 'package:sqflite/sqflite.dart';
import 'package:frontend/services/database_helper.dart';
import 'package:frontend/model/plant.dart';

class PlantRepository {
  final dbHelper = DatabaseHelper();

  Future<void> insertPlant(Plant plant) async {
    final db = await dbHelper.database;
    await db.insert('Plant', plant.toJson(forSqlLite: true),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Plant>> fetchAllPlants(var gardenId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Plant', where: 'garden_id = ?', whereArgs: [gardenId]);
    return List.generate(maps.length, (i) => Plant.fromJson(maps[i]));
  }

  Future<List<Plant>> fetchCurrentPlants(var gardenId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Plant', where: 'garden_id = ? AND marked_for_deletion = 0', whereArgs: [gardenId]);
    return List.generate(maps.length, (i) => Plant.fromJson(maps[i]));
  }

  Future<List<Plant>> fetchCurrentAccountPlants(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Plant', where: 'account_id = ? AND marked_for_deletion = 0', whereArgs: [accountId]);
    return List.generate(maps.length, (i) => Plant.fromJson(maps[i]));
  }

  Future<List<Plant>> fetchAllAccountPlants(var accountId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Plant', where: 'account_id = ?', whereArgs: [accountId]);
    return List.generate(maps.length, (i) => Plant.fromJson(maps[i]));
  }

  Future<Plant?> fetchPlantId(var plantId) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Plant', where: 'id = ?', whereArgs: [plantId]);
    if (maps.length > 0) {
      return Plant.fromJson(maps.first);
    } else {
      // return null;
    }
  }

  Future<void> updatePlant(Plant plant) async {
    final db = await dbHelper.database;
    await db.update(
      'Plant',
      plant.toJson(forSqlLite: true),
      where: 'id = ?',
      whereArgs: [plant.id],
    );
  }

  Future<void> deletePlant(var id) async {
    final db = await dbHelper.database;
    await db.delete(
      'Plant',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
  Future<void> markForDeletion(var id) async {
    final db = await dbHelper.database;
    await db.update(
      'Plant',
      {'marked_for_deletion': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}

