import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/model/ForecastModel.dart';
import 'package:new_app/model/WeatherModel.dart';
import 'package:new_app/services/ForecastService.dart';
import 'package:new_app/services/WeatherService.dart';
import 'package:velocity_x/velocity_x.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  bool isDataFetched = false;

  // api key
  final weatherService = WeatherService("1c6a79075cdea7f0378df4d969daed50");
  final forecastService = ForecastService();
  late Weather _weather;
  late List _forecast;
  late String cityName;

  _fetchWeather() async {
    String cityname = await weatherService.getCurrentCity();

    //get weather for city

    final weather = await weatherService.getWeather(cityname);
    final forecast = await forecastService.getForecast(cityname);

    setState(() {
      _weather = weather;
      _forecast = forecast;
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
      backgroundColor: Colors.white,
      body: Container(
        // color: Colors.white,
        child: !isDataFetched
            ? const Center(
                child:
                    CircularProgressIndicator(), //until weather obj is initialized
              )
            : Center(
                child: Container(
                  padding: EdgeInsets.only(top: 60, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          Text(
                            _weather.cityName.toString() + "",
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.black,
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w500),
                          ),
                          Text(
                            adjustCasing(_weather.mainCondition.toString()) +
                                "",
                            style: const TextStyle(
                                fontSize: 23,
                                color: Color.fromARGB(208, 5, 5, 1),
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w300),
                          ),
                        ],
                      ),
                      Container(
                          child: Lottie.asset(
                              getDisplayAnimation(_weather.mainCondition))),
                      Text(
                        _weather.temperature.toString() + "°",
                        style: TextStyle(
                            fontSize: 35,
                            color: Colors.black,
                            letterSpacing: 3),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, right: 20),
                        height: 280,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(12, 12, 12, 12),
                          borderRadius: BorderRadius.circular(
                              20), // Adjust the value to control the curve
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              padding: EdgeInsets.only(left: 20, right: 20),
                              width: MediaQuery.of(context).size.width,
                              alignment: Alignment.centerLeft,
                              child: const Text(
                                "TODAY'S FORECAST",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                            Container(
                                height: 200,
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [getForecast(),VerticalDivider(),getForecast(),VerticalDivider(),getForecast(),VerticalDivider(),getForecast(),VerticalDivider(),getForecast(),VerticalDivider(),getForecast()],
                                )),
                            // Container( //used to prevent this from expanding into the parent ocntainer
                            //   child:
                            // )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget getForecast() {
    return Container(
      padding: EdgeInsets.all(7),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "9:00 AM",
            style: TextStyle(fontSize: 18),
          ),
          Lottie.asset(getDisplayAnimation(_weather.mainCondition),
              width: 100, height: 100),
          Text(
            "45°",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }

  String adjustCasing(String string) {
    List<String> split = string.split(" ");
    String firstLetter = "";
    String word = "";

    for (int i = 0; i < split.length; i++) {
      firstLetter = split[i][0].toUpperCase();
      word = word + " " + firstLetter + split[i].substring(1);
    }

    print(_forecast.length.toString() + " is the length"); //forecast list

    return word;
  }

  String getDisplayAnimation(String desc) {
    // desc = "fog";
    print(desc);

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
    }

    // return "assets/sun.json";
    return "";
  }
}
