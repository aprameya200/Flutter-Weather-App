import 'dart:ffi';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/config/constants.dart';
import 'package:new_app/database/WeatherDatabase.dart';
import 'package:new_app/helpers/DisplayHelper.dart';
import 'package:new_app/helpers/ShowDrawer.dart';
import 'package:new_app/model/ForecastModel.dart';
import 'package:new_app/model/SavedLocation.dart';
import 'package:new_app/model/WeatherModel.dart';
import 'package:new_app/services/ForecastService.dart';
import 'package:new_app/services/WeatherService.dart';
import 'package:new_app/services/shared_preferences.dart';
import 'package:new_app/widgets/initial_widget.dart';
import 'package:skeleton_animation/skeleton_animation.dart';
import 'package:toastification/toastification.dart';
import 'package:velocity_x/velocity_x.dart';

import '../helpers/Converters.dart';
import '../rough/MyHomePage.dart';
import '../widgets/toast_notification.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage>
    with SingleTickerProviderStateMixin {
  bool isDataFetched = false;
  bool isCurrentLocation = true;
  bool containsLocation = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  // api key
  final weatherService = WeatherService("1c6a79075cdea7f0378df4d969daed50");
  final forecastService = ForecastService();
  late Weather _weather;
  late List _forecast;
  late String cityName;

  double screenHeight = 0.0;
  double screenWidth = 0.0;

  _initializeSavedLocations(List<String> locations) async{

    WeatherDatabase weatherDB = WeatherDatabase();

    for(int i = 0; i< locations.length; i ++){
      final weather = await weatherService.getWeather(cityName);
      weatherDB.insertWeather(weather, WEATHER_TABLE);
    }

    weatherService.getWeatherDB();

    final forecast = await forecastService.getForecast(cityName);
  }

  _fetchWeather(String? cityName) async {
    bool containsLocation =
        await SharedPreferencesManager.containsLocation(cityName ?? "");
    print("Contains location from  init" + containsLocation.toString());
    print(cityName);

    setState(() {
      isDataFetched = false;
      this.containsLocation = containsLocation;
    });

    if (cityName == null) {
      cityName = await weatherService.getCurrentCity(); //if city is null
      setState(() {
        isCurrentLocation = true;
      });
    } else {
      if (!containsLocation) {
        print(_animationController.value);

        if (_animationController.value == _animationController.lowerBound) {
          setState(() {
            _rotateIcon();
          });
        }
      } else {
        if (_animationController.value == _animationController.upperBound) {
          setState(() {
            _rotateIcon();
          });
        }
      }

      setState(() {
        isCurrentLocation = false;
      });
    }

    //get weather for city

    final weather = await weatherService.getWeather(cityName);

    weatherService.getWeatherDB();

    final forecast = await forecastService.getForecast(cityName);

    setState(() {
      _weather = weather;
      _forecast = forecast;
      isDataFetched = true;
      this.cityName = cityName!;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchWeather(null);

    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: 2.5,
    ).animate(_animationController);
  }

  void _rotateIcon() {
    if (_animationController.status == AnimationStatus.completed) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }

    //   _animationController.forward();
    // _animationController.reverse();
  }

  //fetch weather

  //weather animations
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    print("Containg status when building: " + containsLocation.toString());

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: ShowDrawer(_fetchWeather),
        body: Padding(
          padding: const EdgeInsets.only(top: 7),
          child: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                  centerTitle: false,
                  automaticallyImplyLeading: false, //removes the leading
                  toolbarHeight: screenHeight * 0.06,
                  title: Align(
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Builder(
                            builder: (context) => GestureDetector(
                                onTap: () {
                                  Scaffold.of(context)
                                      .openDrawer(); //wasnt being rebuilt before cus it was not a stl
                                },
                                child: Container(
                                  alignment: Alignment.centerLeft,
                                  child: const Icon(
                                    Icons.menu,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                ))),
                        Spacer(
                          flex: 2,
                        ),
                        Builder(
                            builder: (context) => GestureDetector(
                                onTap: () async {
                                  bool saveLocation =
                                      await SharedPreferencesManager
                                          .toggleFavouritesList(
                                              _weather.cityName);

                                  //show this if scuccess
                                  // ToastNotification().showToast(context,_weather.cityName);

                                  _rotateIcon();
                                  // _animationController.forward();
                                },
                                child: isCurrentLocation
                                    ? const Icon(
                                        CarbonIcons.location,
                                        size: 35,
                                        color: Colors.black,
                                      )
                                    : AnimatedBuilder(
                                        animation: _animation,
                                        builder: (BuildContext context,
                                            Widget? child) {
                                          return Transform.rotate(
                                            angle: _animation.value *
                                                (3.141592653 / 2),
                                            // 90 degrees in radians
                                            child: const Icon(
                                              CarbonIcons.close,
                                              size: 40,
                                              color: Colors.black,
                                            ),
                                          );
                                        },
                                      ))),
                      ],
                    ),
                  )
                  ),
            ],
            body: Container(
              color: Colors.transparent,
              child: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Container(
                      height: screenHeight * 1.75,
                      // color: Colors.blue,
                      padding: EdgeInsets.only(bottom: 10),
                      child: InitialWidgets(context, screenHeight, screenWidth, isDataFetched, isDataFetched ? _weather : FILLER_WEATHER, addWidgets)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget addWidgets(BuildContext context, String date) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double containerHeight = MediaQuery.of(context).size.height * 0.33;

    return !isDataFetched
        ? Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Skeleton(
                textColor: const Color.fromARGB(50, 50, 50, 50),
                height: containerHeight,
                width: screenWidth,
                borderRadius: BorderRadius.circular(screenWidth * 0.05),
                style: SkeletonStyle.text))
        : Container(
            margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            height: containerHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              // color: Colors.green,
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
                        fontSize: getFontSize(screenHeight, FONT_FORECAST_DATE),
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
                    // physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: getForecast(date, screenWidth, screenHeight),
                  ),
                ),
              ],
            ),
          );
  }

  List<Widget> getForecast(
      String date, double screenHeight, double screenWidth) {
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
                    // forecast.time.toString(),
                    style: TextStyle(
                        fontSize: getFontSize(screenHeight, FONT_FORECAST_TIME),
                        letterSpacing: 1,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(176, 0, 0, 0)),
                  ),
                  Lottie.asset(
                      DisplayHelper.getDisplayAnimation(
                          forecast.mainCondition, 0, forecast.time),
                      width: screenWidth * 0.113,
                      height: screenHeight * 0.25),
                  Text(
                    "  ${forecast.temperature.round()} °",
                    style: TextStyle(
                        fontSize: getFontSize(
                            screenHeight, FONT_FORECAST_TEMPERATURE),
                        fontWeight: FontWeight.w400),
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
