import 'dart:async';

import 'package:new_app/model/ForecastModel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/WeatherModel.dart';

class WeatherDatabase {
  static Database? _database;

  Future<Database> get database async {
    //<inside> is the return value
    if (_database != null) return _database!;

    _database = await initDB();
    return _database!;
  }

  Future<Database> initDB() async {
    final path = join(await getDatabasesPath(), 'Weather.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE FORECAST (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        temperature DOUBLE,
        mainCondition TEXT,
        time TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE WEATHER (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        temperature DOUBLE,
        mainCondition TEXT
      )
    ''');
  }

  Future<int> insert(Forecast data, String tableName) async {
    Database db = await database;
    return await db.insert(tableName, data.toMap());
  }

  Future<List<Map<String, dynamic>>> getAllData(String tableName) async {
    Database db = await database;
    return await db.query(tableName);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database schema updates here if needed
  }


  Future<List<Weather>> getWeather() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('weather');

    return List.generate(maps.length, (index) {
      return Weather.fromMap(maps[index]);
    });
  }

  Future<List<Forecast>> getForecast() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('forecast');

    return List.generate(maps.length, (index) {
      return Forecast.fromMap(maps[index]);
    });
  }
}
