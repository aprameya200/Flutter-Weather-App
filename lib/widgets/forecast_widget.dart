import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/model/ForecastModel.dart';

import '../config/constants.dart';
import '../helpers/Converters.dart';
import '../helpers/DisplayHelper.dart';

class ForecastWidget  {

  List<Widget> getForecast(
      String date, double screenHeight, double screenWidth,List _forecast) {
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
          Container(
            child: Text(
              Converters.convertTime(forecast.time),
              // forecast.time.toString(),
              style: TextStyle(
                  fontSize: getFontSize(screenHeight, FONT_FORECAST_TIME),
                  letterSpacing: 1,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(176, 0, 0, 0)),
            ),
          ),
          Container(
            child: Lottie.asset(
                DisplayHelper.getDisplayAnimation(
                    forecast.mainCondition, 0, forecast.time),
                width: screenWidth * 0.24,
                height: screenHeight * 0.1),
          ),
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
        .toList() ;//convert to list; // Remove the last VerticalDivider(.. means additional operation)
  }

}
