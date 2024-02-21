
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

class ColorConstants{

  static const Color cardbg = Color(0xffF5F7F8);
}


