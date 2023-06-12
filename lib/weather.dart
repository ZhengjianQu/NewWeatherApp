import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'DataStructure/weather_model.dart';
import 'global_variables.dart';

class Weather extends StatefulWidget {
  final WeatherData weatherData;

  const Weather({Key? key, required this.weatherData}) : super(key: key);

  @override
  WeatherState createState() => WeatherState();
}

class WeatherState extends State<Weather> {


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: Directionality(
        textDirection: TextDirection.ltr,
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundPath()),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Container(
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
                                    _weatherData!.main,
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
                                              0x48, 0x31, 0x9D, 0.2
                                          ),
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
                                                      0xFF, 0xFF, 0xFF, 0.6
                                                  )
                                              ),
                                            ),
                                            Text(
                                              _weatherData!.feelsLike
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontSize: 28,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white
                                              ),
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
                                              'Visibility',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color.fromRGBO(
                                                      0xFF, 0xFF, 0xFF, 0.6)),
                                            ),
                                            Text(
                                                '${_weatherData!.visibility} m',
                                                style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromRGBO(
                                                    0xFF, 0xFF, 0xFF, 1)),
                                            ),
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
                                            Stack(
                                              children: [
                                                DottedBorder(
                                                  borderType: BorderType.Circle,
                                                  strokeWidth: 6,
                                                  color: const Color.fromRGBO(255, 255, 255, 0.2),
                                                  child: Container(
                                                    width: 36,
                                                    height: 36,
                                                    margin: const EdgeInsets.all(20),
                                                  ),
                                                ),
                                                Positioned.fill(
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          (_weatherData!.windSpeed * 3.6).toStringAsFixed(2),
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight: FontWeight.bold,
                                                              color: Color.fromRGBO(
                                                                  0xFF, 0xFF, 0xFF, 1)),),
                                                        const Text(
                                                            'km/h',
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight.bold,
                                                            color: Color.fromRGBO(
                                                                0xFF, 0xFF, 0xFF, 1)),),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )
                                          ]
                                        )
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
