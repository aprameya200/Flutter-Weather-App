import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:new_app/database/WeatherDatabase.dart';

import '../model/ForecastModel.dart';
import '../model/WeatherModel.dart';

import 'package:http/http.dart'
    as http; //means this files uses the methods in http.dart file
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
const API_KEY_1 = "95489aa1b1958a07261d681b6c8206de";
const API_KEY_2 = "1c6a79075cdea7f0378df4d969daed50";


class WeatherService {
  late final String apiKey;
  final dbHelper = WeatherDatabase();

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {

    // try {
      final response = await http.get(Uri.parse(
          '$BASE_URL?q=$cityName&units=metric&appid=$API_KEY_1'));


      if (response.statusCode == 200) {
        // saveToDatabase(Weather.fromJSON(
        //     jsonDecode(response.body))); //saving the api data to database

        return Weather.fromJSON(
            jsonDecode(response.body)); //constructor that creates and object
      }
      else {
        final response = await http.get(Uri.parse(
            '$BASE_URL?q=$cityName&units=metric&appid=$API_KEY_2'));

        if (response.statusCode == 200) {
          // saveToDatabase(Weather.fromJSON(
          //     jsonDecode(response.body))); //saving the api data to database

          return Weather.fromJSON(
              jsonDecode(response.body));
        }else{
          throw Exception("Failed to load weather data");
        }
      }
    // }
  }


  void saveToDatabase(Weather weather) async {
    final db = await dbHelper.database;
    await db.insert('weather', weather.toMap());
  }

  Future<List<Weather>> getWeatherDB() async {
    final List<Weather> weathers = await dbHelper.getWeather();
    for (final weather in weathers) {
      print('CityName: ${weather.cityName}, Temp: ${weather.temperature}');
    }

    return weathers;
  }

  Future<List<Forecast>> getForecastDB() async{
    final List<Forecast> forecast = await dbHelper.getForecast();
    return forecast;

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

    // print(placemark[1].toString());

    return placemark[1].locality.toString() ?? "as";
  }

}
