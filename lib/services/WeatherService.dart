import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:new_app/database/WeatherDatabase.dart';

import '../model/WeatherModel.dart';

import 'package:http/http.dart'
    as http; //means this files uses the methods in http.dart file
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  late final String apiKey;
  final dbHelper = WeatherDatabase();

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {

    try {
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=95489aa1b1958a07261d681b6c8206de'));

      if (response.statusCode == 200) {
        saveToDatabase(Weather.fromJSON(
            jsonDecode(response.body))); //saving the api data to database

        return Weather.fromJSON(
            jsonDecode(response.body)); //constructor that creates and object
      } else {
        throw Exception("Failed to load weather data");
      }
    } catch (Exception) {
      throw ("Unable to connect to API");
    }
  }


  void saveToDatabase(Weather weather) async {
    final db = await dbHelper.database;
    await db.insert('weather', weather.toMap());
  }

  void getWeatherDB() async {
    final List<Weather> weathers = await dbHelper.getWeather();
    for (final weather in weathers) {
      print('CityName: ${weather.cityName}, Age: ${weather.temperature}');
    }
  }

  Future<String> getCurrentCity() async {
    //getting permission from user

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      forceAndroidLocationManager: true,
    );

    //convert the location into a list of placemark objects
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');

    //extract the city name from the first placemark

    String city = "";

    if (placemark[1].subLocality.toString() == "") {
      city = placemark[1].locality.toString();
    } else {
      city = placemark[1].subLocality.toString();
    }

    return placemark[1].locality.toString() ?? "as";
  }

}
