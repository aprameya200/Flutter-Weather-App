import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_app/rough/MyHomePage.dart';
import 'package:new_app/rough/SliversPage.dart';

import 'pages/WeatherPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build

    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.white, // Change this color to the desired one
      statusBarColor: Colors.white, // Change this color to the desired one
      systemNavigationBarIconBrightness: Brightness.dark, // Light or dark icons
      statusBarIconBrightness: Brightness.dark, // Light or dark icons
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WeatherPage(),
      theme: ThemeData(fontFamily: 'Montserrat'),
    );
  }
}
