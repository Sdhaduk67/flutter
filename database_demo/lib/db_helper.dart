import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _db;
  Future<Database> getDb() async {
    if (_db != null) {
      return _db!;
    }

    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'database_demo.db');

    _db = await openDatabase(dbPath, version: 1, onCreate: onCreate);
    return _db!;
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contact_master (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        mobile TEXT
      )''');
  }
}
