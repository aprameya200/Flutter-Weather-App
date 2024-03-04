import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:new_app/model/ForecastModel.dart';
import 'package:new_app/model/WeatherModel.dart';
import 'package:new_app/widgets/add_widgets.dart';
import 'package:velocity_x/velocity_x.dart';

import '../config/constants.dart';
import '../helpers/DisplayHelper.dart';

class InitialWidgets extends StatelessWidget{

  final BuildContext buildContext;
  final double screenHeight;
  final double screenWidth;
  final bool isDataFetched;
  final Weather _weather;
  final List _forecast;

  InitialWidgets(this.buildContext, this.screenHeight, this.screenWidth, this.isDataFetched, this._weather, this._forecast);

  @override
  Widget build(BuildContext context) {
    return initWidget(context, screenHeight, screenWidth, isDataFetched, _weather,_forecast);
  }

  Widget initWidget(
      BuildContext context, double screenHeight, double screenWidth, bool isDataFetched, Weather? _weather, List _forecast) {
    List<Widget> displayWidgets = [
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          !isDataFetched
              ? SizedBox()
              : AutoSizeText(
            _weather?.cityName ?? "",
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
                  _weather?.mainCondition.toString() ?? ""),
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
            _weather?.mainCondition ?? "", _weather?.time ?? 0, "")),
      ),
      !isDataFetched
          ? SizedBox()
          : Text(
        //Temperature
        " ${_weather?.temperature.round() ?? ""}°",
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
    mainbodyWidgets.add(AddWidgets().addWidgets(context, DateTime.now().toString(), isDataFetched,_forecast,screenHeight,screenWidth));
    mainbodyWidgets.add(SizedBox(height: 30));

    //Tommorow
    mainbodyWidgets.add( AddWidgets().addWidgets(context,DateTime.now().add(Duration(days: 1)).toString(), isDataFetched,_forecast,screenHeight,screenWidth));
    mainbodyWidgets.add(SizedBox(height: 30));

    //Day after
    mainbodyWidgets.add( AddWidgets().addWidgets(context,DateTime.now().add(Duration(days: 2)).toString(), isDataFetched,_forecast,screenHeight,screenWidth));

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: mainbodyWidgets,
    );
  }
}
