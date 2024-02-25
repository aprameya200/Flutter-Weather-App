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
import 'package:new_app/helpers/DisplayHelper.dart';
import 'package:new_app/helpers/ShowDrawer.dart';
import 'package:new_app/model/ForecastModel.dart';
import 'package:new_app/model/SavedLocation.dart';
import 'package:new_app/model/WeatherModel.dart';
import 'package:new_app/services/ForecastService.dart';
import 'package:new_app/services/WeatherService.dart';
import 'package:new_app/services/shared_preferences.dart';
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

class _WeatherPageState extends State<WeatherPage> with SingleTickerProviderStateMixin{
  bool isDataFetched = false;
  bool isCurrentLocation = true;

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

  _fetchWeather(String? cityName) async {
    setState(() {
      isDataFetched = false;
    });

    if(cityName == null ){
      cityName = await weatherService.getCurrentCity(); //if city is null
      setState(() {
        isCurrentLocation = true;
      });
    } else{
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
  }

  //fetch weather

  //weather animations
  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: ShowDrawer().initDrawer(context, _fetchWeather),
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
                                  Scaffold.of(context).openDrawer();
                                },
                                child: Container(alignment: Alignment.centerLeft,
                                  child: const Icon(
                                    Icons.menu,
                                    size: 35,
                                    color: Colors.black,
                                  ),
                                ))),
                        Spacer(flex: 2,),
                        Builder(
                            builder: (context) => GestureDetector(
                                onTap: () async {
                                  bool saveLocation = await SharedPreferencesManager.addToFavouritesList(_weather.cityName);

                                  //show this if scuccess
                                  ToastNotification().showToast(context,_weather.cityName);
                                  _rotateIcon();

                                },
                                child:isCurrentLocation ? const Icon(
                                  CarbonIcons.location,
                                  size: 35,
                                  color: Colors.black,
                                ) :
                                AnimatedBuilder(
                                  animation: _animation,
                                  builder: (BuildContext context, Widget? child) {
                                    return Transform.rotate(
                                      angle: _animation.value * (3.141592653 / 2), // 90 degrees in radians
                                      child:
                                      const Icon(
                                        CarbonIcons.add,
                                        size: 40,
                                        color: Colors.black,
                                      ),
                                    );
                                  },
                                ),)),
                      ],
                    ),
                  )
                  // leading: Builder(
                  //       builder: (context) => TextButton(
                  //           onPressed: () {
                  //             Scaffold.of(context).openDrawer();
                  //           },
                  //           child: const Icon(
                  //             Icons.menu,
                  //             size: 35,
                  //             color: Colors.black,
                  //           ))),
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
                      child: initWidget(context, screenHeight, screenWidth)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget initWidget(
      BuildContext context, double screenHeight, double screenWidth) {
    List<Widget> displayWidgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          !isDataFetched
              ? SizedBox()
              : AutoSizeText(
                  _weather.cityName,
                  style: TextStyle(
                      fontSize: getFontSize(screenHeight, FONT_SMALL),
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w500),
                ),
          // const SizedBox(height: 2,),
          !isDataFetched
              ? SizedBox()
              : Container(
                  width: screenWidth * 0.8,
                  child: AutoSizeText(
                    DisplayHelper.adjustCasing(
                        _weather.mainCondition.toString()),
                    // DisplayHelper.adjustCasing("light intensity drizzle rain"),
                    maxLines: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: getFontSize(screenHeight, FONT_MEDIUM),
                        color: Color.fromARGB(208, 5, 5, 1),
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w300),
                  ),
                ),
        ],
      ), //Location and condition
      Container(
        //image
        height: screenHeight * 0.3,
        width: screenWidth * 0.55,
        //image
        child: !isDataFetched
            ? SizedBox()
            : Lottie.asset(DisplayHelper.getDisplayAnimation(
                _weather.mainCondition, _weather.time, "")),
      ),
      !isDataFetched
          ? SizedBox()
          : Text(
              //Temperature
              " ${_weather.temperature.round()}°",
              style: TextStyle(
                  fontSize: getFontSize(screenHeight, FONT_TEMPERATURE_LARGE),
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 3),
            ),
    ];

    List<Widget> mainbodyWidgets = [
      !isDataFetched
          ? Container(
              height: screenHeight * 0.53,
              child: LoadingAnimationWidget.beat(
                  color: HexColor('#FFC82F'), size: 150))
          : Container(
              height: screenHeight * 0.53,
              // color: Colors.yellow,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: displayWidgets, //adding location, image and temp
              ),
            ),
      SquareBox(10),
    ];

    // adding the forecast in this list
    // Today
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
