// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:lottie/lottie.dart';
// import 'package:new_app/model/ForecastModel.dart';
// import 'package:new_app/model/WeatherModel.dart';
// import 'package:new_app/services/ForecastService.dart';
// import 'package:new_app/services/WeatherService.dart';
// import 'package:velocity_x/velocity_x.dart';
//
// import 'MyHomePage.dart';
//
// class SliversPage extends StatefulWidget {
//   const SliversPage({super.key});
//
//   @override
//   State<SliversPage> createState() => _SliversPageState();
// }
//
// class _SliversPageState extends State<SliversPage> {
//   bool isDataFetched = false;
//
//   // api key
//   final weatherService = WeatherService("1c6a79075cdea7f0378df4d969daed50");
//   final forecastService = ForecastService();
//   late Weather _weather;
//   late List _forecast;
//   late String cityName;
//
//   double screenHeight = 0.0;
//
//   _fetchWeather() async {
//     String cityname = await weatherService.getCurrentCity();
//
//     //get weather for city
//
//     final weather = await weatherService.getWeather(cityname);
//     final forecast = await forecastService.getForecast(cityname);
//
//     setState(() {
//       _weather = weather;
//       _forecast = forecast;
//       isDataFetched = true;
//       cityName = cityname;
//     });
//   }
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     _fetchWeather();
//   }
//
//   //fetch weather
//
//   //weather animations
//   @override
//   Widget build(BuildContext context) {
//     screenHeight = MediaQuery.of(context).size.height;
//     // displayWidgets.remove(CircularProgressIndicator());
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: !isDataFetched
//           ? const Center(
//               child:
//                   CircularProgressIndicator(), //until weather obj is initialized
//             )
//           : CustomScrollView(
//               // shrinkWrap: true,
//               slivers: [
//                 SliverToBoxAdapter(
//                   child: Container(
//                     color: Colors.blue,
//                     height: 300,
//                     width: 30,
//                   ),
//                 ),
//                 SliverPersistentHeader(delegate: MyHeader(),pinned: true,),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     color: Colors.green,
//                     height: 300,
//                     width: 30,
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     color: Colors.blue,
//                     height: 300,
//                     width: 30,
//                   ),
//                 ),
//                 SliverToBoxAdapter(
//                   child: Container(
//                     color: Colors.pink,
//                     height: 300,
//                     width: 30,
//                   ),
//                 ),
//
//               ],
//             ),
//     );
//   }
//
//   //Adds new forecast block to the screen
//   Widget addWidgets(BuildContext context, String date) {
//     return Container(
//       margin: EdgeInsets.only(left: 20, right: 20),
//       height: 280,
//       width: MediaQuery.of(context).size.width,
//       decoration: BoxDecoration(
//         color: Color.fromARGB(12, 12, 12, 12),
//         borderRadius:
//             BorderRadius.circular(20), // Adjust the value to control the curve
//       ),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Container(
//             padding: EdgeInsets.only(left: 20, right: 20),
//             width: MediaQuery.of(context).size.width,
//             alignment: Alignment.centerLeft,
//             child: Text(
//               displayForecastDate(date),
//               style: TextStyle(
//                   fontSize: 17,
//                   letterSpacing: 1,
//                   fontWeight: FontWeight.w500,
//                   color: Color.fromARGB(176, 0, 0, 0)),
//             ),
//           ),
//           Container(
//               height: 200,
//               child: ListView(
//                 scrollDirection: Axis.horizontal,
//                 children: getForecast(date),
//               )),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> getForecast(String date) {
//     List<Widget> forecastWidget = [];
//     int index = 0;
//
//     for (Forecast forecast in _forecast) {
//       print(date + " is the dae");
//       print(forecast.time.toString() + " is the forecast");
//
//       if (dateFormatter(forecast.time) == dateFormatter(date)) {
//         forecastWidget.add(Container(
//           padding: EdgeInsets.all(7),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               Text(
//                 convertTime(forecast.time),
//                 style: const TextStyle(
//                     fontSize: 17,
//                     letterSpacing: 1,
//                     fontWeight: FontWeight.w500,
//                     color: Color.fromARGB(176, 0, 0, 0)),
//               ),
//               Lottie.asset(getDisplayAnimation(forecast.mainCondition),
//                   width: 100, height: 100),
//               Text(
//                 "  " + forecast.temperature.round().toString() + " °",
//                 style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
//               ),
//             ],
//           ),
//         ));
//
//         // if(convertTime(forecast.time) == "3 AM") break;
//
//         DateTime currentDate = DateTime.now();
//         // Add 3 days to the current date
//         DateTime newDate = currentDate.add(Duration(days: 3));
//
//         print(newDate.day);
//
//         forecastWidget.add(VerticalDivider());
//       }
//     }
//
//     return forecastWidget;
//   }
//
//   String dateFormatter(String date) {
//     DateTime dateParser = DateTime.parse(date);
//
//     return DateFormat('d').format(dateParser);
//   }
//
//   String displayForecastDate(String date) {
//     DateTime dateParser = DateTime.parse(date);
//
//     if (DateTime.parse(date).day == DateTime.now().day) {
//       return "TODAY'S FORECAST";
//     } else {
//       return DateFormat('dd MM yyyy').format(dateParser);
//     }
//   }
//
//   String convertTime(String time) {
//     DateTime dateTime = DateTime.parse(time);
//     String parsedTime = DateFormat('h a').format(dateTime);
//     return parsedTime.toString();
//   }
//
//   String adjustCasing(String string) {
//     List<String> split = string.split(" ");
//     String firstLetter = "";
//     String word = "";
//
//     for (int i = 0; i < split.length; i++) {
//       firstLetter = split[i][0].toUpperCase();
//       word = word + " " + firstLetter + split[i].substring(1);
//     }
//
//     return word;
//   }
//
//   String getDisplayAnimation(String desc) {
//     // desc = "fog";
//     switch (desc) {
//       case "clear sky":
//         return "assets/sun.json";
//       case "broken clouds":
//         return "assets/sun_and_clouds.json";
//       case "overcast clouds":
//         return "assets/clouds_line.json";
//       case "few clouds":
//         return "assets/sun_and_clouds.json";
//       case "scattered clouds":
//         return "assets/sun_and_clouds.json";
//       case "light rain":
//         return "assets/sun_and_rain.json";
//       case "moderate rain":
//         return "assets/sun_and_rain.json";
//       case "heavy rain":
//         return "assets/thunder_rain.json";
//       case "thunderstorm":
//         return "assets/clouds_thunder.json";
//       case "mist":
//       case "fog":
//         return "assets/fog.json";
//     }
//
//     // return "assets/sun.json";
//     return "";
//   }
// }
