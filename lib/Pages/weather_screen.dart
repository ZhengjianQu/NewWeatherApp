// Package
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart'; // 风向的虚线圈
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
// File
import '../DataStructure/forecast_model.dart';
import '../DataStructure/weather_model.dart';
import '../global_variables.dart';
import '../ComponentLayout/drawer_widget.dart';

dynamic previousWeatherData;
dynamic previousForecastData;

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

  int temperature(double temp){
    if(isCelsius == true){
      return temp.round();
    }else{
      return (temp * 9 / 5 + 32).round();
    }

  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setPosition(position.latitude,position.longitude);
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get current location';
      });
    }
  }

  Future<void> _getCityCoordinates(String cityName) async {
    try {
      List<Location> locations = await locationFromAddress(cityName);
      if (locations.isNotEmpty) {
        Location firstLocation = locations.first;
        setPosition(firstLocation.latitude,firstLocation.longitude);
      } else {
        setState(() {
          _errorMessage = 'Failed to get city coordinates';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to get city coordinates';
      });
    }
  }

  Future<void> _fetchWeatherData() async {
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

  Future<ForecastData> fetchForecastData() async {
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
    _fetchWeatherData();
    forecastData = fetchForecastData();
    modifiable = false;
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
      previousWeatherData = _weatherData;
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      setState(() async {
                        modifiable = true;
                        await _getCurrentLocation();
                        modifiable = false;
                        _fetchWeatherData();
                        forecastData = fetchForecastData();
                      });
                    },
                    icon: const Icon(
                      Icons.location_on_outlined,
                      color: Colors.deepPurple,
                    ),
                  ),
                  fillColor: Colors.white,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Search City...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: _showClearButton ? null : const Icon(Icons.search),
                  suffixIconColor: Colors.grey,
                ),
                onSubmitted: (String value) async {
                  setState(() async {
                    modifiable = true;
                    await _getCityCoordinates(_searchController.text);
                    modifiable = false;
                    _fetchWeatherData();
                    forecastData = fetchForecastData();
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
          actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                isCelsius = !isCelsius; // 切换摄氏度和华氏度
                if (isCelsius) {
                  unitSymbol = "°C";
                } else {
                  unitSymbol = "°F";
                }
              });
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.black),
              foregroundColor: MaterialStateProperty.all(Colors.white),
            ),
            child: Text(
              isCelsius ? '°C' : '°F', // 根据当前状态显示°C或°F
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      drawer: const DrawerWidget(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackgroundPath()),
            fit: BoxFit.cover,
          ),
        ),
        child: PageView(
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
      ),
    );
  }

  Widget _buildWeatherPage(weatherData){
    if (weatherData == null && previousWeatherData != null) {
      return _buildDataPage(previousWeatherData); // 使用上一次的数据加载页面
    }else if(weatherData == null){
      return const CircularProgressIndicator();
    }else {
      return _buildDataPage(weatherData); // 使用当前的数据加载页面
    }
  }

  Widget _buildDataPage(weatherData) {
    return Center(
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
            createText(weatherData!.name, 64),
            const SizedBox(height: 8),
            createText('${temperature(weatherData!.temperature)}$unitSymbol', 64),
            const SizedBox(height: 8),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.network(
                    'https://openweathermap.org/img/wn/${weatherData!.iconUrl}@2x.png',
                    width: 90,
                    height: 90,
                  ),
                  const SizedBox(width: 16),
                  createText(weatherData!.main, 28),
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
                            createText('Feels like', 14, color: Colors.white60),
                            createText('${temperature(weatherData!.feelsLike)}$unitSymbol', 28),
                            createText('Similar to the actual temperature', 12, color: Colors.white60),
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
                            createText('Humidity', 14, color: Colors.white60),
                            createText(weatherData!.humidity.toString(), 24),
                            createText('The dew point is '
                                '${(weatherData!.temperature - ((100 - weatherData!.humidity) / 5)).toStringAsFixed(1)} '
                                'right now.', 13, color: Colors.white60),
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
                            createText('Visibility', 14, color: Colors.white60),
                            createText('${weatherData!.visibility} m', 24, color: Colors.white),
                            createText('Max 10km.', 17, color: Colors.white60),
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
                                createText('Wind', 14, color: Colors.white60),
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
                                            createText((weatherData!.windSpeed * 3.6).toStringAsFixed(2), 16),
                                            createText('km/h', 14, color: Colors.white),
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
    );
  }

  Widget _buildForecastPage(forecastData){
    if (forecastData == null) {
      return const CircularProgressIndicator(); // 或者其他处理空值的 Widget
    }
    return Center(
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
                                '${temperature(weatherInfo.temperature)}$unitSymbol',
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
                            'https://openweathermap.org/img/wn/${weatherInfo.iconUrl}@2x.png',
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
    );
  }
}
