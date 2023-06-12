import 'package:intl/intl.dart' hide TextDirection;

class WeatherForcastData {
  final String temperature;
  final String weather;
  final String time;
  final String week;
  final String date;
  final String iconUrl;

  WeatherForcastData({
    required this.temperature,
    required this.weather,
    required this.date,
    required this.week,
    required this.time,
    required this.iconUrl,
  });

  factory WeatherForcastData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    final temperature = main['temp'].round().toString();
    final weatherDescription = weather['main'].toString();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final date = DateFormat('MM/dd').format(timestamp);
    final week = DateFormat('EEEE').format(timestamp);// Format the timestamp
    final time = DateFormat('HH:mm').format(timestamp);

    return WeatherForcastData(
      temperature: temperature,
      weather: weatherDescription,
      date: date,
      week: week,
      time: time,
      iconUrl:
      'http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png',
    );
  }
}


class ForecastData {
  final List<WeatherForcastData> forecastList;

  ForecastData({required this.forecastList});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final forecastList = List<WeatherForcastData>.from(json['list'].map((data) {
      return WeatherForcastData.fromJson(data);
    }));

    return ForecastData(forecastList: forecastList);
  }
}