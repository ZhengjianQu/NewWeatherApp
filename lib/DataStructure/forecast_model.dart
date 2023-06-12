import 'weather_model.dart';


class ForecastData {
  final List<WeatherData> forecastList;

  ForecastData({required this.forecastList});

  factory ForecastData.fromJson(Map<String, dynamic> json) {
    final forecastList = List<WeatherData>.from(json['list'].map((data) {
      return WeatherData.fromJson(data);
    }));

    return ForecastData(forecastList: forecastList);
  }
}