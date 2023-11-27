import 'dart:convert';

import 'package:new_app/WeatherModel.dart';

class Forecast {
  late final String cityName;
  late final double temperature;
  late final String mainCondition;
  late String time;


  Forecast(this.cityName, this.temperature, this.mainCondition,
      this.time); //constyructor


  factory Forecast.fromJSON(Map<String, dynamic> json,int index) {
    // Map<String, dynamic> city = json["city"]['name'];
    // Map<String, dynamic> temp = json["list"]['0']["main"]["temp"];
    // Map<String,
    //     dynamic> desc = json["list"]['0']["weather"]["0"]["description"];
    // Map<String, dynamic> src =

    String indexString = index.toString();

    return Forecast(json["city"]['name'], json["list"][indexString]["main"]["temp"],
      json["list"][indexString]["weather"]["0"]["description"],json["list"][indexString]["dt_txt"]);
  }

}