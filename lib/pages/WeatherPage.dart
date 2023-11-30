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

    weatherService.getWeatherDB();

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
      drawer: initDrawer(),
      body: !isDataFetched
          ? const Center(
              child:
                  CircularProgressIndicator(), //until weather obj is initialized
            )
          : Container(
              padding: EdgeInsets.only(top: 50),
              color: Colors.transparent,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      height: screenHeight * 1.75,
                      // color: Colors.red,
                      padding: EdgeInsets.only(bottom: 10),
                      child: initWidget(context)),
                ),
              ),
            ),
    );
  }

  Drawer initDrawer() {
    return Drawer(
      elevation: 0,
      shape: null,
      backgroundColor: Color(0xFFFFFFFF),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 50.0, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SearchBar(
              hintText: "Search",
              shape: MaterialStatePropertyAll(ContinuousRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20)))),
              overlayColor: MaterialStatePropertyAll(Colors.yellow),
              backgroundColor:
                  MaterialStatePropertyAll(Color.fromARGB(12, 12, 12, 12)),
              leading: Icon(Icons.search),
              elevation: MaterialStatePropertyAll(0),
            ),
            SquareBox(20),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Container(child: Lottie.asset("assets/mountains.json",height: 100),),
                      Text(
                        "Kathmandu",
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(
                        "Cloudy",
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                  Container(
                    height: 50,
                    alignment: Alignment.topRight,
                    child: Text(
                      "19°",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget initWidget(BuildContext context) {
    List<Widget> displayWidgets = [
      Container(
        alignment: Alignment.centerLeft,
        child: Builder(
            builder: (context) => TextButton(
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(
                  Icons.menu,
                  size: 40,
                  color: Colors.black,
                ))),
      ),
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
      ), //Location and condition
      Container(
          //image
          child: Lottie.asset(
              DisplayHelper.getDisplayAnimation(_weather.mainCondition))),
      Text(
        //Temperature
        " ${_weather.temperature.round()}°",
        style: const TextStyle(
            fontSize: 50,
            color: Colors.black,
            fontWeight: FontWeight.w500,
            letterSpacing: 3),
      ),
    ];

    List<Widget> mainbodyWidgets = [
      Container(
        height: screenHeight * 0.58,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: displayWidgets, //adding location, image and temp
        ),
      ),
      SquareBox(10),
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
    double fontSize = screenWidth * 0.037;

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
            Converters.dateFormatter(forecast.time) ==
            Converters.dateFormatter(date))
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
        .expand((widget) => [
              widget,
              const VerticalDivider()
            ]) //adds new widget after each element widget
        .toList() //convert to list
      ..removeLast(); // Remove the last VerticalDivider(.. means additional operation)
  }

  addLocation() {}
}
