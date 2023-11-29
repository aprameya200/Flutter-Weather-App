import 'package:intl/intl.dart';

class Converters{

  static String dateFormatter(String date){
    DateTime dateParser = DateTime.parse(date);

    return DateFormat('d').format(dateParser);
  }

  static String displayForecastDate(String date){
    DateTime dateParser = DateTime.parse(date);

    if(DateTime.parse(date).day == DateTime.now().day) return "TODAY'S FORECAST";
    else return DateFormat('dd MM yyyy').format(dateParser);

  }


  static String convertTime(String time) {
    DateTime dateTime = DateTime.parse(time);
    String parsedTime = DateFormat('h a').format(dateTime);
    return parsedTime.toString();
  }
}