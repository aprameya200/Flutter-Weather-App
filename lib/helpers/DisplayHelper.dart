import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../config/constants.dart';

class DisplayHelper {
  static String getDisplayAnimation(String desc, int time, String? dateString) {
    int hourTime = time == 0
        ? DateTime.parse(dateString!).hour
        : DateTime.fromMillisecondsSinceEpoch(time * 1000).hour;

    bool isDark = hourTime < 6 || hourTime >= 16 || hourTime == 0;

    // sunset time needs to be added
    // also time according to place starting with current time

    // desc = "light intensity drizzle rain";

    switch (desc) {
      case "clear sky":
        return isDark ? "assets/moon.json" : "assets/sun.json";
      case "few clouds":
      case "scattered clouds":
        return isDark
            ? "assets/moon_and_clouds.json"
            : "assets/sun_and_clouds.json";
      case "overcast clouds":
      case "broken clouds":
        return "assets/clouds_line.json";
      case "heavy intensity rain":
      case "very heavy rain":
      case "extreme rain":
      case "freezing rain":
      case "shower rain":
      case "ragged shower rain":
      case "light rain":
      case "light intensity shower rain":
      case "moderate rain":
      case "light intensity drizzle":
      case "drizzle":
      case "heavy intensity drizzle":
      case "light intensity drizzle rain":
      case "drizzle rain":
      case "heavy intensity drizzle rain":
      case "shower rain and drizzle":
      case "heavy shower rain and drizzle":
      case "shower drizzle":
        return isDark
            ? "assets/moon_and_rain.json"
            : "assets/sun_and_rain.json";
      case "heavy rain":
      case "thunderstorm with light rain":
      case "thunderstorm with rain":
      case "thunderstorm with heavy rain":
        return "assets/thunder_rain.json";
      case "light thunderstorm":
      case "thunderstorm":
      case "heavy thunderstorm":
      case "ragged thunderstorm":
      case "thunderstorm with light drizzle":
      case "thunderstorm with drizzle":
      case "thunderstorm with heavy drizzle":
        return "assets/clouds_thunder.json";
      case "mist":
      case "fog":
      case "haze":
        return "assets/fog.json";
      case "light snow":
      case "snow":
      case "heavy snow":
      case "sleet":
      case "light shower sleet":
      case "shower sleet":
      case "light rain and snow":
      case "rain and snow":
      case "light shower snow":
      case "shower snow":
      case "heavy shower snow":
        return isDark
            ? "assets/moon_and_snow.json"
            : "assets/sun_and_snow.json";
      default:
        return isDark ? "assets/moon.json" : "assets/sun.json";
    }
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

  static Widget addLocationButton() {
    return const Row(
      children: [Icon(Icons.add), Text("Add Location")],
    );
  }
}

double getFontSize(double screenHeight, String fontSize) {
  switch (fontSize) {
    case FONT_SMALL:
      return screenHeight * 0.027;
    case FONT_MEDIUM:
      return screenHeight * 0.035;
    case FONT_TEMPERATURE_LARGE:
      return screenHeight * 0.05;
    case FONT_FORECAST_DATE:
      return screenHeight * 0.018;
    case FONT_FORECAST_TIME:
      return screenHeight * 0.024;
    case FONT_FORECAST_TEMPERATURE:
      return screenHeight * 0.04;
  }
  double newSize = 20;
  return newSize;
}
