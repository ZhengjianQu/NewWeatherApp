import 'package:intl/intl.dart' hide TextDirection;

class WeatherData {
  final double temperature;
  final double tempMin;
  final double tempMax;
  final String sunrise;
  final String sunset;
  final double feelsLike;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int visibility;
  final String main;
  final String iconUrl;
  final String name;

  WeatherData({
    required this.temperature,
    required this.tempMin,
    required this.tempMax,
    required this.sunrise,
    required this.sunset,
    required this.feelsLike,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.visibility,
    required this.main,
    required this.iconUrl,
    required this.name,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final sunrise = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000));
    final sunset = DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000));
    return WeatherData(
      temperature: json['main']['temp'],
      tempMin: json['main']['temp_min'],
      tempMax: json['main']['temp_max'],
      sunrise: sunrise,
      sunset: sunset,
      feelsLike: json['main']['feels_like'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'],
      windDeg: json['wind']['deg'],
      visibility: json['visibility'],
      main: json['weather'][0]['main'],
      iconUrl:json['weather'][0]['icon'],
      name: json['name'],
    );
  }
}
