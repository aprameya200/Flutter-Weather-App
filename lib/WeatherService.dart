import 'dart:convert';

import 'package:geocoding/geocoding.dart';

import 'WeatherModel.dart';

import 'package:http/http.dart'
    as http; //means this files uses the methods in http.dart file
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';

class WeatherService {
  static const BASE_URL = "https://api.openweathermap.org/data/2.5/weather";
  late final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?q=$cityName&units=metric&appid=1c6a79075cdea7f0378df4d969daed50'));
    //
    // final response = await http
    //     .get(Uri.parse(BASE_URL + '?q=' + cityName + '&units=metric&appid=' + apiKey));
    // 'https://api.openweathermap.org/data/2.5/weather?q=kathmandu&units=metric&appid=1c6a79075cdea7f0378df4d969daed50'));

    if (response.statusCode == 200) {
      return Weather.fromJSON(
          jsonDecode(response.body)); //constructor that creates and object
    } else {
      throw Exception("Failed to load weather data");
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

    print(position.toString() + " Im Here");

    //convert the location into a list of placemark objects
    List<Placemark> placemark = await placemarkFromCoordinates(
        position.latitude, position.longitude,
        localeIdentifier: 'en');

    print(placemark.toString() + " Placemark String");


    //extract the city name from the first placemark

      String city = "";

      if (placemark[1].subLocality.toString() == "") {
        city = placemark[1].locality.toString();
      } else {
        city = placemark[1].subLocality.toString();
      }

      print(placemark.toString());

      return placemark[1].locality.toString() ?? "as";
    }


    // return "Kathmandu";
  // }
}
