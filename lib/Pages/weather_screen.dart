// Package
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart'; // 风向的虚线圈
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:toggle_switch/toggle_switch.dart';
// File
import '../DataStructure/forecast_model.dart';
import '../DataStructure/weather_model.dart';
import '../global_variables.dart';
import '../SearchBar/navigation_drawer_widget.dart';




class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WeatherPageState createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  int _currentPageIndex = 0;
  int selectedUnitIndex = 0;

  WeatherData? _weatherData;
  late Future<ForecastData> forecastData;

  String _errorMessage = '';
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

  void updateWeather(String description) {
    List<String> atmosphere =  ["Mist", "Smoke", "Haze", "Dust", "Fog", "Sand", "Ash", "Squall", "Tornado"];
    // link to weather Data structure:
    // https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
    if(atmosphere.contains(description)){
      weather = "Atmosphere";
    }else{
      weather = description;
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

  Future<void> _fetchWeatherData(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
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

  Future<ForecastData> fetchForecastData(double latitude, double longitude) async {
    final url = Uri.parse(
        'https://api.openweathermap.org/data/2.5/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      // 解析 API 响应的 JSON 数据并创建 ForecastData 对象
      return ForecastData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }

  void _onTextChanged(String value) {
    setState(() {
      _showClearButton = value.isNotEmpty;
    });
  }

  void _onClear() {
    setState(() {
      _searchController.clear();
      _showClearButton = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    forecastData = fetchForecastData(latitude, longitude);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if(_weatherData!=null){
      updateWeather(_weatherData!.main);
    }
    return Scaffold(
      //extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFf9f9f9),
      //this is the sidebar menu
      appBar: AppBar(
          backgroundColor: const Color(0xE6000000),
          elevation: 0.0,
          title: Stack(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onTextChanged,
                style : const TextStyle(color: Colors.grey),
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        location = "current";
                        _onClear();
                      });
                    },
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.deepPurple,
                    ),
                  ),
                  fillColor: const Color(0xE2ffffff),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search City...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: _showClearButton ? null : const Icon(Icons.search),
                  suffixIconColor: Colors.grey,
                ),
                onSubmitted: (String value){
                  setState(() {
                    location = _searchController.text;
                    _onClear();
                  });
                },
              ),
              Visibility(
                visible: _showClearButton,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: _onClear,
                          icon: const Icon(Icons.clear)
                      )
                    ]
                ),
              ),
            ],
          ),
          centerTitle: true,
          //leading: IconButton(
          //  onPressed: () {},
          //  icon: const Icon(Icons.menu),
          //  color: Colors.deepPurple,
          //),
          actions: <Widget>[
            ToggleSwitch(
              initialLabelIndex: selectedUnitIndex,
              totalSwitches: 2,
              labels: const ['°C', '°F'],
              onToggle: (index) {
                setState(() {
                  selectedUnitIndex = index!;
                  if (index == 0) {
                    units = "metric";
                    unitSymbol = "°C";
                  }
                  else {
                    units = "imperial";
                    unitSymbol = "°F";
                  }
                });
                //getData();
                updateWeather(_weatherData!.main);
              },
            )
          ]
      ),
      drawer: const NavigationDrawerWidget(),

      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentPageIndex = index;
          });
        },

        children: [
          _buildWeatherPage(_weatherData),
          _buildForecastPage(forecastData),
        ],
      ),
    );
  }
}

Widget _buildWeatherPage(weatherData){
  if (weatherData == null) {
    return const CircularProgressIndicator(); // 或者其他处理空值的 Widget
  }
  return Container(
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
                  weatherData!.name,
                  style: const TextStyle(
                      fontSize: 64,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text(
                  '${weatherData!.temperature}°C',
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
                        weatherData!.iconUrl,
                        width: 45,
                        height: 45,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        weatherData!.main,
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
                                  weatherData!.feelsLike
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
                                  weatherData!.humidity.toString(),
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'The dew point is ${(weatherData!.temperature - ((100 - weatherData!.humidity) / 5)).toStringAsFixed(1)} right now.',
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
                                  '${weatherData!.visibility} m',
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
                                                  (weatherData!.windSpeed * 3.6).toStringAsFixed(2),
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
            ),
        ),
      ),
  );
}

Widget _buildForecastPage(forecastData){
  if (forecastData == null) {
    return const CircularProgressIndicator(); // 或者其他处理空值的 Widget
  }
  return Container(
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage(getBackgroundPath()),
        fit: BoxFit.cover,
      ),
    ),
    child: Center(
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 30, vertical: 30
        ), // 设置左右和上下的间距
        decoration: BoxDecoration(
            borderRadius:
            BorderRadius.circular(20), // 设置圆角半径为10
            color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)
        ),
        child: FutureBuilder<ForecastData>(
          future: forecastData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final forecastData = snapshot.data!;
              final forecastList = forecastData.forecastList;
              return ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: forecastList.length,
                itemBuilder: (context, index) {
                  final weatherInfo = forecastList[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius:BorderRadius.circular(50),
                      color: const Color.fromRGBO(
                          0x48, 0x31, 0x9D, 0.2),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                weatherInfo.time,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                '${weatherInfo.temperature}°C',
                                style: const TextStyle(
                                    fontSize: 48, fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              Text(
                                weatherInfo.weather,
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Image.network(
                            weatherInfo.iconUrl,
                            width: 90,
                            height: 90,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return const Text('Failed to fetch forecast data');
            } else {
              return const CircularProgressIndicator();
            }
          },
        ),
      ),
    ),
  );
}

