import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

String apikey = '8dab3e149329990d1d9456befa085601';

Color color00 = const Color.fromRGBO(0x0, 0x0, 0x0, 0.8);
Color color01 = const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2);
Color color02 = const Color.fromRGBO(0xFF, 0xFF, 0xFF, 0.6);

class WeatherData {
  final int temperature;
  final int feelsLike;
  final int minTemperature;
  final int maxTemperature;
  final int pressure;
  final int humidity;
  //final double windSpeed;
  //final int windDeg;
  //final int visibility;
  final String description;
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
    //required this.windSpeed,
    //required this.windDeg,
    //required this.visibility,
    required this.description,
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
      //windSpeed: json['wind']['speed'],
      //windDeg: json['wind']['deg'],
      //visibility: json['visibility'],
      description: json['weather'][0]['description'],
      iconUrl:
          'http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png',
      name: json['name'],
      lon: json['coord']['lon'],
      lat: json['coord']['lat'],
    );
  }
}

class WeatherApp extends StatefulWidget {
  const WeatherApp({super.key});

  @override
  WeatherAppState createState() => WeatherAppState();
}

class WeatherAppState extends State<WeatherApp> {
  WeatherData? _weatherData;
  String _errorMessage = '';
  String backgroundImage =
      'assets/images/sunny.png'; // Background image path or color code

  void updateBackgroundBasedOnWeatherData(String weatherCondition) {
    switch (weatherCondition.toLowerCase()) {
      case 'clear sky':
        backgroundImage = 'assets/images/sunny.png';
        break;
      case 'clouds':
        backgroundImage = 'assets/images/cloudy.png';
        break;
      case 'rain and snow':
        backgroundImage = 'assets/images/rainy.png';
        //TODO:rain and snow.jpg';
        break;
      case 'rain':
      case 'shower sleet':
        backgroundImage = 'assets/images/rainy.png';
        break;
      case 'snow':
        backgroundImage = 'assets/images/snow.png';
        break;
      case 'thunderstorm':
        backgroundImage = 'assets/images/thunderstorm.png';
        break;
      default:
        backgroundImage = 'assets/images/sunny.png';
      //TODO
    }
  }

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apikey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        _weatherData = WeatherData.fromJson(json.decode(response.body));
        _errorMessage = '';
      });
    } else {
      setState(() {
        _errorMessage = 'Failed to load data from OpenWeatherMap API';
      });
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      await _fetchWeatherData(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get current location';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (_weatherData != null) {
      updateBackgroundBasedOnWeatherData(_weatherData!.description);
    }
    return MaterialApp(
      title: 'Weather App',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: SizedBox(
              height: kToolbarHeight - 10,
              child: TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Enter the city name',
                  hintStyle: const TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  try {
                    final position = await Geolocator.getCurrentPosition(
                      desiredAccuracy: LocationAccuracy.high,
                    );
                    _fetchWeatherData(position.latitude, position.longitude);
                  } catch (e) {
                    setState(() {
                      _errorMessage = 'Failed to get current location';
                    });
                  }
                },
              )
            ],
          ),
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(backgroundImage),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: _weatherData != null
                    ? Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 30), // 设置左右和上下的间距
                        decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // 设置圆角半径为10
                            color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weatherData!.name,
                              style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_weatherData!.temperature}°C',
                              style: const TextStyle(
                                  fontSize: 64,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    _weatherData!.iconUrl,
                                    width: 45,
                                    height: 45,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    _weatherData!.description,
                                    style: const TextStyle(
                                        fontSize: 28, color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0x48, 0x31, 0x9D, 0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Feels like',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0xFF, 0xFF, 0xFF, 0.6)),
                                            ),
                                            Text(
                                              _weatherData!.feelsLike
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            const Text(
                                              'Similar to the actual temperature.',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0x48, 0x31, 0x9D, 0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Humidity',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0xFF, 0xFF, 0xFF, 0.6)),
                                            ),
                                            Text(
                                              _weatherData!.humidity.toString(),
                                              style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              'The dew point is ${(_weatherData!.temperature - ((100 - _weatherData!.humidity) / 5)).toStringAsFixed(1)} right now.',
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0x48, 0x31, 0x9D, 0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Visibility',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0xFF, 0xFF, 0xFF, 0.6)),
                                            ),
                                            //Text(_weatherData!.visibility as String),
                                            const Text(
                                              'Max 10km.',
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: AspectRatio(
                                      aspectRatio: 1.0,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromRGBO(
                                              0x48, 0x31, 0x9D, 0.2),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: const EdgeInsets.all(20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Wind',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0xFF, 0xFF, 0xFF, 0.6)),
                                            ),
                                            //Text('${_weatherData!.windSpeed} m/s'),
                                            //Text('${_weatherData!.windDeg}'),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ))
                    : Text(
                        _errorMessage,
                        style: const TextStyle(fontSize: 24),
                      )),
          ),
          bottomNavigationBar: BottomAppBar(
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/forecast'),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Forecast',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
