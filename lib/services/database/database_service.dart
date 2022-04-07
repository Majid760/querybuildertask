import 'package:path/path.dart';
import 'package:querybuildertask/services/database/database_config.dart';
import 'package:querybuildertask/services/database/database_tables.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  DatabaseService._init();
  static Database? _database;
  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, DatabaseConfig.databaseName);
    Sqflite.setDebugModeOn(true);
    return await openDatabase(path,
        version: DatabaseConfig.databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(DataBaseTable.userTable);
  }

  // closign the database connection
  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
