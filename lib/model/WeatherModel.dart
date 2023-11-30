class Weather {
  late final String cityName;
  late final double temperature;
  late final String mainCondition;

  Weather(this.cityName,this.temperature, this.mainCondition);

  // Factory coonstructor, returns an instance of the class by creating an object of it baseed on the json
  factory Weather.fromJSON(Map<String, dynamic> json) {
    return Weather(json['name'], json['main']['temp'].toDouble(),
        json['weather'][0]['description']);
  }

  Map<String, dynamic> toMap() {
    return {
      'cityName': cityName,
      'temperature': temperature,
      'mainCondition': mainCondition,
    };
  }

  static Weather fromMap(Map<String, dynamic> map){
    return Weather(map['cityName'],map['temperature'],map['mainCondition']);
  }


}
