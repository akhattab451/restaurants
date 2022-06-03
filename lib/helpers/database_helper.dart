import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  const DatabaseHelper._init();
  static const instance = DatabaseHelper._init();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDb();

    return _database!;
  }

  _initDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'retail.db'),
      onCreate: (db, version) async {
        await db.execute(
          '''CREATE TABLE users(
          id INTEGER PRIMARY KEY,
          image TEXT,
          name TEXT,
          gender INTEGER,
          email TEXT,
          level INTEGER,
          password TEXT)''',
        );
      },
      version: 1,
    );
  }
}
