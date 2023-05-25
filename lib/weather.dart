import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

String apikey = '8dab3e149329990d1d9456befa085601';
Color hexColor = const Color.fromRGBO(0x62, 0x0, 0xEE, 1.0);

class WeatherData {
  final int temperature;
  final int feelsLike;
  final int minTemperature;
  final int maxTemperature;
  final int pressure;
  final int humidity;
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
      pressure: json['main']['pressure'],
      humidity: json['main']['humidity'],
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
  String backgroundImage = ''; // Background image path or color code

  void updateBackgroundBasedOnWeatherData(weatherCondition) {
    if (weatherCondition == 'sunny') {
      backgroundImage = 'assets/images/sunny_background.jpg';
    } else if (weatherCondition == 'cloudy') {
      backgroundImage = 'assets/images/cloudy_background.jpg';
    } else {
      backgroundImage = '#FFFFFF'; // Default background color is white
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
    updateBackgroundBasedOnWeatherData(_weatherData!.description);
    return MaterialApp(
      title: 'Weather App',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          backgroundColor: hexColor,
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
                        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30), // 设置左右和上下的间距
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10), // 设置圆角半径为10
                          color: Colors.white.withOpacity(0.5), // 设置半透明的黑色背景
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _weatherData!.name,
                              style: const TextStyle(
                                  fontSize: 36, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${_weatherData!.temperature}°C',
                              style: const TextStyle(
                                  fontSize: 48, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    _weatherData!.iconUrl,
                                    width: 50,
                                    height: 50,
                                  ),
                                  const SizedBox(width: 16),
                                  Text(
                                    _weatherData!.description,
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Feels like ${_weatherData!.feelsLike}°C',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Min: ${_weatherData!.minTemperature}°C / Max: ${_weatherData!.maxTemperature}°C',
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Pressure: ${_weatherData!.pressure} hPa / Humidity: ${_weatherData!.humidity}%',
                              style: const TextStyle(fontSize: 16),
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
