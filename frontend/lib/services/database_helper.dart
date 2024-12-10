import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'garden_journal.db');
    return await openDatabase(path, version: 1, onCreate: _createDb);
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE SyncLog (
      entity TEXT PRIMARY KEY,
      lastSyncTime TEXT,
      lastSyncStatus TEXT,
      lastSyncMessage TEXT
    )
    ''');
    //Note password must be securely hashed and salted.
    await db.execute('''
    CREATE TABLE User (
      id TEXT PRIMARY KEY,
      first_name TEXT,
      last_name TEXT,
      email TEXT,
      password TEXT,
      "created_at" TEXT,
      "updated_at" TEXT
    )
    ''');

    await db.execute('''
    CREATE TABLE User_Accounts (
      id TEXT PRIMARY KEY,
      user_id TEXT,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (user_id) REFERENCES User(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE Garden (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      description TEXT NOT NULL,
      account_id TEXT NOT NULL,
      plants TEXT,
      marked_for_deletion INTEGER DEFAULT 0,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (account_id) REFERENCES User_Accounts(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE Plant (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      germinated INTEGER NOT NULL,
      days_to_harvest INTEGER NOT NULL,
      plant_count INTEGER NOT NULL,
      date_planted TEXT,
      date_germinated TEXT,
      garden_id TEXT NOT NULL,
      journal_id TEXT,
      plantTags TEXT,
      journals TEXT,
      waterSchedules TEXT,
      account_id TEXT NOT NULL,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (account_id) REFERENCES User_Accounts(id),
      FOREIGN KEY (garden_id) REFERENCES Garden(id),
      FOREIGN KEY (journal_id) REFERENCES Journal(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE WaterSchedule (
      id TEXT PRIMARY KEY,
      monday INTEGER,
      tuesday INTEGER,
      wednesday INTEGER,
      thursday INTEGER,
      friday INTEGER,
      saturday INTEGER,
      sunday INTEGER,
      method TEXT,
      notes TEXT,
      plant_id TEXT,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (plant_id) REFERENCES Plant(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE Journal (
      id TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      entry TEXT NOT NULL,
      display_on_garden INTEGER NOT NULL,
      image TEXT,
      category TEXT NOT NULL,
      plant_id TEXT NOT NULL,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (plant_id) REFERENCES Plant(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE Tag (
      id TEXT PRIMARY KEY,
      name TEXT NOT NULL,
      related_plants TEXT,
      account_id TEXT NOT NULL,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (account_id) REFERENCES User_Accounts(id)
    )
    ''');

    await db.execute('''
    CREATE TABLE PlantTags (
      id TEXT PRIMARY KEY,
      plant_id TEXT NOT NULL,
      tag_id TEXT NOT NULL,
      "created_at" TEXT,
      "updated_at" TEXT,
      FOREIGN KEY (plant_id) REFERENCES Plant(id),
      FOREIGN KEY (tag_id) REFERENCES Tags(id)
    )
    ''');
  }
}
