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

