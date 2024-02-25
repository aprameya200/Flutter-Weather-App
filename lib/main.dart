import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_app/config/constants.dart';
import 'package:new_app/pages/UsingRiverpod.dart';
import 'package:new_app/rough/MyHomePage.dart';
import 'package:new_app/rough/SliversPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'pages/WeatherPage.dart';

void main() async{

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    setSystemChrome();


    return ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WeatherPage(),
        theme: ThemeData(fontFamily: 'Montserrat'),
      ),
    );
  }
}
