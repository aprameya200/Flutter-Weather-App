import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/WeatherModel.dart';
import 'package:new_app/WeatherService.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isDataFetched = false;

  // api key
  final weatherService = WeatherService("1c6a79075cdea7f0378df4d969daed50");
  late Weather _weather;
  late String cityName;

  _fetchWeather() async {
    String cityname = await weatherService.getCurrentCity();

    //get weather for city

    final weather = await weatherService.getWeather(cityname);

    setState(() {
      _weather = weather;
      isDataFetched = true;
      cityName = cityname;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather();
  }

  //fetch weather

  //weather animations
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Color.fromARGB(122, 25, 205, 40),
        child: !isDataFetched
            ? const Center(
                child:
                    CircularProgressIndicator(), //until weather obj is initialized
              )
            : Center(
              child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _weather.mainCondition.toString() + "",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                      Container(
                          color: Colors.cyan,
                          child: Lottie.asset('assets/sun.json')),
                      Text(
                        _weather.temperature.toString() + "°",
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),Text(
                        _weather.cityName.toString(),
                        style: TextStyle(fontSize: 30, color: Colors.black),
                      ),
                    ],
                  ),
                ),
            ),
      ),
    );
  }
}
