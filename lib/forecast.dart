import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' hide TextDirection;
import 'dart:convert';

String apikey = '8dab3e149329990d1d9456befa085601';

class WeatherData {
  final String temperature;
  final String weather;
  final String time;
  final String iconUrl;
  final String date;

  WeatherData({
    required this.temperature,
    required this.weather,
    required this.date,
    required this.time,
    required this.iconUrl,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'];
    final weather = json['weather'][0];

    final temperature = main['temp'].round().toString();
    final weatherDescription = weather['description'].toString();
    final timestamp = DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000);
    final date = DateFormat('MM/dd').format(timestamp); // Format the timestamp
    final time = DateFormat('HH:mm').format(timestamp);

    return WeatherData(
      temperature: temperature,
      weather: weatherDescription,
      date: date,
      time: time,
      iconUrl:
          'http://openweathermap.org/img/w/${json['weather'][0]['icon']}.png',
    );
  }
}

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

class Forecast extends StatefulWidget {
  const Forecast({Key? key}) : super(key: key);

  @override
  ForecastState createState() => ForecastState();
}

class ForecastState extends State<Forecast> {
  late Future<ForecastData> forecastData;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    forecastData = _getCurrentLocation();
  }

  Future<ForecastData> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return fetchForecastData(position.latitude, position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get current location';
      });
      rethrow;
    }
  }

  Future<ForecastData> fetchForecastData(
      double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apikey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // 解析 API 响应的 JSON 数据并创建 ForecastData 对象
      return ForecastData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Forecast'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
          ),
          body: FutureBuilder<ForecastData>(
            future: forecastData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else if (!snapshot.hasData) {
                return const Center(
                  child: Text('No data available'),
                );
              } else {
                final forecastData = snapshot.data!;
                final forecastList = forecastData.forecastList;

                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: forecastList.length,
                  itemBuilder: (context, index) {
                    final weatherInfo = forecastList[index];

                    return Container(
                      width: 200, // Adjust the width according to your needs
                      margin: const EdgeInsets.all(8.0),
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            weatherInfo.date,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            weatherInfo.time,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 48),
                          Text(
                            '${weatherInfo.temperature}°C',
                            style: const TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          Image.network(weatherInfo.iconUrl),
                          const SizedBox(height: 16),
                          Text(
                            weatherInfo.weather,
                            style: const TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
