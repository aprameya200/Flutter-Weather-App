import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayHelper{

  static String getDisplayAnimation(String desc) {
    // desc = "fog";
    switch (desc) {
      case "clear sky":
        return "assets/sun.json";
      case "broken clouds":
        return "assets/sun_and_clouds.json";
      case "overcast clouds":
        return "assets/clouds_line.json";
      case "few clouds":
        return "assets/sun_and_clouds.json";
      case "scattered clouds":
        return "assets/sun_and_clouds.json";
      case "light rain":
      case "light intensity shower rain":
        return "assets/sun_and_rain.json";
      case "moderate rain":
        return "assets/sun_and_rain.json";
      case "heavy rain":
        return "assets/thunder_rain.json";
      case "thunderstorm":
        return "assets/clouds_thunder.json";
      case "mist":
      case "fog":
        return "assets/fog.json";
      default:
        return "assets/sun.json";
    }

    // return "assets/sun.json";
    return "";
  }

  static String adjustCasing(String string) {
    List<String> split = string.split(" ");
    String firstLetter = "";
    String word = "";

    for (int i = 0; i < split.length; i++) {
      firstLetter = split[i][0].toUpperCase();
      word = word + " " + firstLetter + split[i].substring(1);
    }
    return word;
  }

  static Widget addLocationButton(){
    return Row(children: [Icon(Icons.add),Text("Add Location")],);
  }
}