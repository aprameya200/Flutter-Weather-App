class Weather {
  late final String cityName;
  late final double temperature;
  late final String mainCondition;
  late final int time;

  Weather(this.cityName,this.temperature, this.mainCondition, this.time);

  // Factory coonstructor, returns an instance of the class by creating an object of it baseed on the json
  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(json['name'], json['main']['temp'].toDouble(),
        json['weather'][0]['description'],json['dt']);
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'mainCondition': mainCondition,
      'dt': time,
    };
  }

  static Weather fromMap(Map<String, dynamic> map){
    return Weather(map['cityName'],map['temperature'],map['mainCondition'],map['dt'] ?? 0);
  }


}
