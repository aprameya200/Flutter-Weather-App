import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:new_app/widgets/forecast_widget.dart';
import 'package:skeleton_animation/skeleton_animation.dart';

import '../config/constants.dart';
import '../helpers/Converters.dart';
import '../helpers/DisplayHelper.dart';
import '../model/ForecastModel.dart';

class AddWidgets {
  // const AddWidgets({required this.buildContext, required this.date, required this.isDataFetched, required this.getForecast});
  //
  // final BuildContext buildContext;
  // final String date;
  // final bool isDataFetched;
  // final Function getForecast;
  //
  // @override
  // Widget build(BuildContext context) {
  //   return addWidgets(buildContext, date,isDataFetched,getForecast);
  // }

  Widget addWidgets(BuildContext context, String date, bool isDataFetched,
      List _forecast, double screenHeight, double screenWidth) {
    // double screenWidth = MediaQuery.of(context).size.width;
    // double screenHeight = MediaQuery.of(context).size.height;
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
                    children: ForecastWidget().getForecast(
                        date, screenHeight, screenWidth, _forecast),
                  ),
                ),
              ],
            ),
          );
  }
}
