import 'dart:convert';

import '../model/ForecastModel.dart';
import 'package:http/http.dart' as http;



class ForecastService {

  String API_KEY_2 = "95489aa1b1958a07261d681b6c8206de";

  Future<List> getForecast(String cityName) async {
    final response = await http.get(Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?q=$cityName&units=metric&appid=1c6a79075cdea7f0378df4d969daed50'));

    if (response.statusCode == 200) {
      return Forecast.getForecastList(jsonDecode(response.body));
    } else {
      throw Exception("Error fetching forecast");
    }
  }
}
