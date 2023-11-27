import 'package:new_app/model/ForecastModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class WeatherDatabase {
  static Database? _database;
  static const String tableName = 'forecast';

  Future<Database> get database async { //<inside> is the return value
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'Weather.db');
    return await openDatabase(path, version: 1, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        cityName INTEGER PRIMARY KEY AUTOINCREMENT,
        temperature DOUBLE,
        mainCondition TEXT,
        time TEXT,
      )
    ''');
  }

  Future<int> insert(Forecast data) async {
    Database db = await database;
    return await db.insert(tableName, data.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllData() async {
    Database db = await database;
    return await db.query(tableName);
  }
}
