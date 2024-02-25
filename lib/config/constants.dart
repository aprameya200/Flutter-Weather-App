
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void setSystemChrome(){
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white, // Change this color to the desired one
    statusBarColor: Colors.white, // Change this color to the desired one
    systemNavigationBarIconBrightness: Brightness.dark, // Light or dark icons
    statusBarIconBrightness: Brightness.dark, // Light or dark icons
  ));
}

const String FONT_SMALL = "small";
const String FONT_MEDIUM = "medium";
const String FONT_TEMPERATURE_LARGE = "temperature_large";
const String FONT_FORECAST_DATE = "forecast_date";
const String FONT_FORECAST_TIME = "forecast_time";
const String FONT_FORECAST_TEMPERATURE = "forecast_temperature";

class ColorConstants{
  static const Color cardbg = Color(0xffF5F7F8);
}


const String CURRENT_LOCATION = "current_location";
const String FAVOURITES_LIST = "favourites_list";



