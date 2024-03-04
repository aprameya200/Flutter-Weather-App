import 'dart:async';

import 'package:new_app/config/constants.dart';
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
        time TEXT,
        dt INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE WEATHER (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cityName TEXT,
        temperature DOUBLE,
        mainCondition TEXT,
        dt INTEGER
      )
    ''');
  }

  Future<bool> containsLocation(String address) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      WEATHER_TABLE,
      where: 'cityName = ?',
      whereArgs: [address],
    );

    return result
        .isNotEmpty; // Return true if data for India exists, false otherwise
  }

  Future<int> insertForecast(List<dynamic> data, String tableName) async {
    Database db = await database;
    var retrunvAl;

    for (int i = 0; i < data.length; i++) {
      retrunvAl = await db.insert(tableName, data[i].toMap());
    }

    return retrunvAl;
  }

  Future<int> insertWeather(Weather data, String tableName) async {
    Database db = await database;

    if (await containsLocation(data.cityName) == false) {
      return await db.insert(tableName, data.toMap());
    } else {
      return 0;
    }
  }

  Future<List<Forecast>> getDataByName(String name) async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query(
      FORECAST_TABLE,
      where: 'cityName = ?',
      whereArgs: [name],
    );

    print(maps.toString());

    return List.generate(maps.length, (i) {
      return Forecast.fromMap(maps[i]);
    });
  }

  Future<void> toggleLocation(Weather weather, List<dynamic> forecast) async {
    List<Forecast> forecastList = forecast.map((e) => e as Forecast).toList();

    if (await containsLocation(weather.cityName)) {
      await deleteWeather(weather, WEATHER_TABLE) > 0
          ? print("Success")
          : print("Failure");
      await deleteForecast(forecastList, FORECAST_TABLE);
    } else {
      await insertWeather(weather, WEATHER_TABLE);
      await insertForecast(forecast, FORECAST_TABLE);
    }
  }

  Future<int> updateForecast(List<dynamic> data, String tableName) async {
    Database db = await database;
    var retrunvAl;

    List<Forecast> forecastList = data.map((e) => e as Forecast).toList();

    for (int i = 0; i < data.length; i++) {
      retrunvAl = await db.update(tableName, forecastList[i].toMap(),
          where: 'cityName = ?', whereArgs: [forecastList[i].cityName]);
    }

    return retrunvAl;
  }



  Future<int> updateWeather(Weather data, String tableName) async {
    Database db = await database;

    return await db.update(tableName, data.toMap(),
        where: 'cityName = ?', whereArgs: [data.cityName]);
  }

  Future<int> deleteForecast(List<Forecast> data, String tableName) async {
    Database db = await database;
    var retrunvAl;

    for (int i = 0; i < data.length; i++) {
      retrunvAl = await db.delete(tableName,
          where: 'cityName = ?', whereArgs: [data[i].cityName]);
    }

    return retrunvAl;
  }

  Future<int> deleteWeather(Weather data, String tableName) async {
    Database db = await database;

    if (await containsLocation(data.cityName) != false) {
      return await db
          .delete(tableName, where: 'cityName = ?', whereArgs: [data.cityName]);
    } else {
      return 0;
    }
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
    final List<Map<String, dynamic>> maps = await db.query(WEATHER_TABLE);

    return List.generate(maps.length, (index) {
      return Weather.fromMap(maps[index]);
    });
  }

  Future<List<Forecast>> getForecast() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(FORECAST_TABLE);

    return List.generate(maps.length, (index) {
      return Forecast.fromMap(maps[index]);
    });
  }
}
