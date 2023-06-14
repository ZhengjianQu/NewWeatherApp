import 'package:intl/intl.dart' hide TextDirection;

class WeatherForecastData {
  final double temperature;
  final String weather;
  final String time;
  final String week;
  final String date;
  final String iconUrl;

  WeatherForecastData({
    required this.temperature,
    required this.weather,
    required this.date,
    required this.week,
    required this.time,
    required this.iconUrl,
  });

  factory WeatherForecastData.fromJson(Map<String, dynamic> json) {
    final timestamp = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final date = DateFormat('MM/dd').format(timestamp);
    final week = DateFormat('EEEE').format(timestamp);// Format the timestamp
    final time = DateFormat('HH:mm').format(timestamp);
    final iconUrl = json['weather'][0]['icon'];

    return WeatherForecastData(
      temperature: json['main']['temp'].toDouble(),
      weather: json['weather'][0]['main'],
      date: date,
      week: week,
      time: time,
      iconUrl:iconUrl,
    );
  }
}


class ForecastData {
  final List<WeatherForecastData> forecastList;
  ForecastData({required this.forecastList});
  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final forecastList = List<WeatherForecastData>.from(json['list'].map((data) {
      return WeatherForecastData.fromJson(data);
    }));
    return ForecastData(forecastList: forecastList);
  }
}