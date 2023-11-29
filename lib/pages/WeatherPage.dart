import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/helpers/DisplayHelper.dart';
import 'package:new_app/model/ForecastModel.dart';
import 'package:new_app/model/WeatherModel.dart';
import 'package:new_app/services/ForecastService.dart';
import 'package:new_app/services/WeatherService.dart';
import 'package:velocity_x/velocity_x.dart';

import '../helpers/Converters.dart';
import '../rough/MyHomePage.dart';

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

  double screenHeight = 0.0;

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
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      body: !isDataFetched
          ? const Center(
              child:
                  CircularProgressIndicator(), //until weather obj is initialized
            )
          : Container(
              // color: Colors.white,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      height: screenHeight * 1.75,
                      padding: EdgeInsets.only(top: 60, bottom: 10),
                      child: initWidget(context)),
                ),
              ),
            ),
    );
  }

  Widget initWidget(BuildContext context) {

    List<Widget> displayWidgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            _weather.cityName,
            style: const TextStyle(
                fontSize: 30,
                color: Colors.black,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500),
          ),
          Text(
            DisplayHelper.adjustCasing(_weather.mainCondition.toString()),
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
              DisplayHelper.getDisplayAnimation(_weather.mainCondition))),
      Text(
        " ${_weather.temperature.round()}°",
        style: const TextStyle(
            fontSize: 50,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 3),
      )
    ];

    List<Widget> mainbodyWidgets = [
      Container(
        height: screenHeight * 0.58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: displayWidgets, //adding the above part in the screen then dding the forecast in this list
        ),
      ),
    ];

    //adding the forecast in this list
    //Today
    mainbodyWidgets.add(addWidgets(context, DateTime.now().toString()));
    mainbodyWidgets.add(SizedBox(height: 30));

    //Tommorow
    mainbodyWidgets.add(
        addWidgets(context, DateTime.now().add(Duration(days: 1)).toString()));
    mainbodyWidgets.add(SizedBox(height: 30));

    //Day after
    mainbodyWidgets.add(
        addWidgets(context, DateTime.now().add(Duration(days: 2)).toString()));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mainbodyWidgets,
    );
  }

  Widget addWidgets(BuildContext context, String date) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerHeight = MediaQuery.of(context).size.height * 0.33;
    double fontSize = screenWidth * 0.05;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
      height: containerHeight,
      width: screenWidth,
      decoration: BoxDecoration(
        color: const Color.fromARGB(12, 12, 12, 12),
        borderRadius: BorderRadius.circular(screenWidth * 0.05),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                Converters.displayForecastDate(date),
                style: TextStyle(
                  fontSize: fontSize,
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(176, 0, 0, 0),
                ),
              ),
            ),
          ),
          Container(
            height: containerHeight * 0.75, // Adjust as needed
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: getForecast(date),
            ),
          ),
        ],
      ),
    );
  }


  List<Widget> getForecast(String date) {
    return _forecast
        .where((forecast) => //single element in the forecast list
            Converters.dateFormatter(forecast.time) == Converters.dateFormatter(date))
        .map((forecast) => Container(
              //maps each elemt of the forecast list as a Container
              padding: const EdgeInsets.all(7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    Converters.convertTime(forecast.time),
                    style: const TextStyle(
                        fontSize: 17,
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(176, 0, 0, 0)),
                  ),
                  Lottie.asset(
                    DisplayHelper.getDisplayAnimation(forecast.mainCondition),
                    width: 100,
                    height: 100,
                  ),
                  Text(
                    "  ${forecast.temperature.round()} °",
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ))
        .expand((widget) => [widget, const VerticalDivider()]) //adds new widget after each element widget
        .toList() //convert to list
      ..removeLast(); // Remove the last VerticalDivider(.. means additional operation)
  }

}
