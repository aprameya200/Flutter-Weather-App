import 'dart:convert';
import 'dart:ffi';

import 'package:new_app/model/WeatherModel.dart';
import 'package:sqflite/sqflite.dart';

class Forecast {
  late final String cityName;
  late final num temperature;
  late final String mainCondition;
  late String time;


  Forecast(this.cityName, this.temperature, this.mainCondition,
      this.time); //constyructor


  static List getForecastList(Map<String, dynamic> json){
    // Map<String, dynamic> city = json["city"]['name'];
    // Map<String, dynamic> temp = json["list"]['0']["main"]["temp"];
    // Map<String, $ flutter pub add sqflite
    //     dynamic> desc = json["list"]['0']["weather"]["0"]["description"];
    // Map<String, dynamic> src =

    // String indexString = index.toString();

    List apiList = json["list"];
    List forecastList = [];

    for(int i = 0;i < apiList.length; i++){
      forecastList.add( Forecast(
          json["city"]['name'],
          json["list"][i]["main"]["temp"],
          json["list"][i]["weather"][0]["description"],
          json["list"][i]["dt_txt"]));
    }

    return forecastList;
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'mainCondition': mainCondition,
      'time': time,
    };
  }

  Forecast fromMap(Map<String, dynamic> map){
    return Forecast(map['cityName'],map['temperature'],map['mainCondition'],map['time']);
  }


}