class WeatherData {
  final int temperature;
  final int feelsLike;
  final int minTemperature;
  final int maxTemperature;
  final int pressure;
  final int humidity;
  final double windSpeed;
  final int windDeg;
  final int visibility;
  final String main;
  final String iconUrl;
  final String name;
  final double lon;
  final double lat;

  WeatherData({
    required this.temperature,
    required this.feelsLike,
    required this.minTemperature,
    required this.maxTemperature,
    required this.pressure,
    required this.humidity,
    required this.windSpeed,
    required this.windDeg,
    required this.visibility,
    required this.main,
    required this.iconUrl,
    required this.name,
    required this.lon,
    required this.lat,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      temperature: json['main']['temp'].round(),
      feelsLike: json['main']['feels_like'].round(),
      minTemperature: json['main']['temp_min'].round(),
      maxTemperature: json['main']['temp_max'].round(),
      pressure: json['main']['pressure'].round(),
      humidity: json['main']['humidity'].round(),
      windSpeed: json['wind']['speed'],
      windDeg: json['wind']['deg'],
      visibility: json['visibility'],
      main: json['weather'][0]['main'],
      iconUrl:
      'http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png',
      name: json['name'],
      lon: json['coord']['lon'],
      lat: json['coord']['lat'],
    );
  }
}
