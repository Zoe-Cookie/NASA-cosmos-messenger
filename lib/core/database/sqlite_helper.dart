import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqliteHelper {
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'nova_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE favorites(
            date TEXT PRIMARY KEY,
            title TEXT,
            explanation TEXT,
            url TEXT,
            media_type TEXT,
            thumbnail_url TEXT
          )
        ''');
        
        await db.execute('''
          CREATE TABLE chat_history(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            text TEXT,
            is_user INTEGER,
            apod_json TEXT
          )
        ''');
      },
    );
  }
}