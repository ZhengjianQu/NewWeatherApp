import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

String apikey = '8dab3e149329990d1d9456befa085601';

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
    print(weatherCondition);
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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('Weather App'),
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${_weatherData!.name}',
                            style: TextStyle(
                                fontSize: 36, fontWeight: FontWeight.bold),
                          ),
                          Image.network(_weatherData!.iconUrl),
                          SizedBox(height: 16),
                          Text(
                            '${_weatherData!.temperature}°C',
                            style: TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${_weatherData!.description}',
                            style: TextStyle(fontSize: 24),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Feels like ${_weatherData!.feelsLike}°C',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Min: ${_weatherData!.minTemperature}°C / Max: ${_weatherData!.maxTemperature}°C',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            'Pressure: ${_weatherData!.pressure} hPa / Humidity: ${_weatherData!.humidity}%',
                            style: TextStyle(fontSize: 16),
                          ),
                          Container(
                            height: 50,
                            alignment: Alignment.bottomCenter,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Color(0xFF000000)),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.0),
                                  ),
                                ),
                              ),
                              onPressed: () => context.go('/forecast'),
                              child: const Text('Forecast'),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        _errorMessage,
                        style: TextStyle(fontSize: 24),
                      )),
          ),
        ),
      ),
    );
  }
}
