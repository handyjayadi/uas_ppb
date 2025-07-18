  import 'package:sqflite/sqflite.dart';
  import 'package:path/path.dart';

  class DBHelper {
    static Database? _database;

    static Future<Database> get database async {
      if (_database != null) return _database!;
      _database = await _initDB();
      return _database!;
    }

    static Future<Database> _initDB() async {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'profiles.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) {
          return db.execute('''
            CREATE TABLE profiles (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              phone TEXT,
              profilePhoto TEXT,
              coverPhoto TEXT,
              quote TEXT
            )
          ''');
        },
      );
    }

    static Future<void> closeDB() async {
      final db = await database;
      await db.close();
      _database = null;
    }
  }
