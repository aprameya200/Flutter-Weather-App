import 'package:auto_size_text/auto_size_text.dart';
import 'package:carbon_icons/carbon_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:toastification/toastification.dart';

class ToastNotification  {

  ToastificationItem showToast(BuildContext context,String cityName){
    return toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.fillColored,
      title: const Text(" Added Succesfully."),
      description: AutoSizeText(" ${cityName} added to favourites.",maxLines: 1,),
      alignment: Alignment.topLeft,
      autoCloseDuration: const Duration(
        seconds: 2,
        milliseconds: 500,
      ),
      animationBuilder: (
          context,
          animation,
          alignment,
          child,
          ) {
        return FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: child,
          ),
        );
      },
      primaryColor: Color(0xffffffff),
      backgroundColor: Color(0xff000000),
      foregroundColor: Color(0xff000000),
      icon: Icon(CarbonIcons.temperature_feels_like),
      borderRadius: BorderRadius.circular(12.0),
      boxShadow: highModeShadow,
      closeButtonShowType: CloseButtonShowType.onHover,
      dragToClose: true,
      // applyBlurEffect: true
    );
  }
}
