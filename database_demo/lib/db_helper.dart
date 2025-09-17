import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbHelper {
  Database? _db;
  Future<Database> getDb() async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDatabase();
    return _db!;
  }

  Future<Database> initDatabase() async {
    String databasePath = await getDatabasesPath();
    String dbPath = join(databasePath, 'database_demo.db');

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) => onCreate(db, version),
    );
  }

  Future<void> onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE contact_master (
      id PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      mobile TEXT
    )''');
  }
}
