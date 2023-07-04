// Package
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;

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
  Future<ForecastData>? _forecastData;

  String _errorMessage = '';
  final PageController _pageController = PageController(initialPage: 0);

  final TextEditingController _searchController = TextEditingController();
  bool _showClearButton = false;

  void updateWeather(String description) {
    List<String> atmosphere = [
      "Mist",
      "Smoke",
      "Haze",
      "Dust",
      "Fog",
      "Sand",
      "Ash",
      "Squall",
      "Tornado"
    ];
    // link to weather Data structure:
    // https://openweathermap.org/weather-conditions#Weather-Condition-Codes-2
    if (atmosphere.contains(description)) {
      weather = "Atmosphere";
    } else {
      weather = description;
    }
  }

  int temperature(double temp) {
    if (isCelsius == true) {
      return temp.round();
    } else {
      return (temp * 9 / 5 + 32).round();
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setPosition(position.latitude, position.longitude);
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
        setPosition(firstLocation.latitude, firstLocation.longitude);
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
      return ForecastData.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch forecast data');
    }
  }

  Future<void> _saveData() async {
    if (_weatherData != null) {
      updateWeather(_weatherData!.main);
      previousWeatherData = _weatherData;
    }
    if (_forecastData != null) {
      previousForecastData = _forecastData;
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
    _getCurrentLocation().then((_) {
      modifiable = false;
      _fetchWeatherData();
      _forecastData = fetchForecastData();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _saveData();
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
              style: const TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      modifiable = true;
                      _getCurrentLocation().then((_) {
                        modifiable = false;
                        _fetchWeatherData();
                        _forecastData = fetchForecastData();
                      });
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
              onSubmitted: (String value) {
                setState(() {
                  modifiable = true;
                  _getCityCoordinates(_searchController.text).then((_) {
                    modifiable = false;
                    _fetchWeatherData();
                    _forecastData = fetchForecastData();
                  });
                });
              },
            ),
            Visibility(
              visible: _showClearButton,
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(onPressed: _onClear, icon: const Icon(Icons.clear))
              ]),
            ),
          ],
        ),
        centerTitle: true,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              setState(() {
                isCelsius = !isCelsius; // Switching between °C and °F
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
              isCelsius
                  ? '°C'
                  : '°F', // Display °C or °F according to current status
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
        child: PageView.builder(
          controller: _pageController,
          scrollDirection:
              MediaQuery.of(context).orientation == Orientation.portrait
                  ? Axis.horizontal
                  : Axis.vertical,
          onPageChanged: (index) {
            setState(() {
              _currentPageIndex = index;
            });
          },
          itemCount: 2, // Set the number of pages
          itemBuilder: (context, index) {
            if (index == 0) {
              return _buildWeatherPage(_weatherData);
            } else {
              return _buildForecastPage(_forecastData);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWeatherPage(weatherData) {
    if (weatherData == null && previousWeatherData != null) {
      return _buildDataPage(previousWeatherData);
    } else if (weatherData == null) {
      return _loadingPage();
    } else {
      return _buildDataPage(weatherData);
    }
  }

  Widget _buildDataPage(weatherData) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8),
        ),
        child: Flex(
          direction: isPortrait ? Axis.vertical : Axis.horizontal,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        weatherData!.name,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '${temperature(weatherData!.temperature)}$unitSymbol',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.network(
                            'https://openweathermap.org/img/wn/${weatherData!.iconUrl}@4x.png',
                            width: 100,
                            height: 100,
                          ),
                          Text(
                            weatherData!.main,
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: isPortrait? 10:5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Feels like',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  '${temperature(weatherData!.feelsLike)}$unitSymbol',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Similar to the actual temperature',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: isPortrait? 10:5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Humidity',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  weatherData!.humidity.toString(),
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'The dew point is '
                                      '${(weatherData!.temperature - ((100 - weatherData!.humidity) / 5)).toStringAsFixed(1)} '
                                      'right now.',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            alignment: Alignment.centerLeft,
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: isPortrait? 10:5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Visibility',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                                Text(
                                  '${weatherData!.visibility}m',
                                  style: const TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const Text(
                                  'Max 10km',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white60,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: isPortrait? 10:5),
                            child: Stack(
                              alignment: Alignment.topLeft,
                              children: [
                                const Positioned(
                                  left: 0,
                                  top: 0,
                                  child: Text(
                                    'Wind',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: Center(
                                      child: Transform.rotate(
                                        angle: math.pi / 180 * weatherData!.windDeg,
                                        alignment: Alignment.center,
                                        child: ColorFiltered(
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white60,
                                            BlendMode.srcIn,
                                          ),
                                          child: Image.asset(
                                            'assets/images/Icons/Compass.png',
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned.fill(
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          (weatherData!.windSpeed * 3.6)
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const Text(
                                          'km/h',
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white60,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
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

  Widget _buildForecastPage(forecastData) {
    if (forecastData == null && previousForecastData != null) {
      return _buildListPage(
          previousForecastData); // Use the previous data load page
    } else if (forecastData == null) {
      return _loadingPage();
    } else {
      return _buildListPage(forecastData); // Use the new data load page
    }
  }

  Widget _buildListPage(forecastData) {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(30),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
        child: FutureBuilder<ForecastData>(
          future: forecastData,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final forecastData = snapshot.data!;
              final forecastList = forecastData.forecastList;
              return ListView.builder(
                scrollDirection: isPortrait ? Axis.vertical : Axis.horizontal,
                itemCount: forecastList.length,
                itemBuilder: (context, index) {
                  final weatherInfo = forecastList[index];
                  return Container(
                    margin: const EdgeInsets.all(8.0),
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(50),
                      color: const Color.fromRGBO(0x48, 0x31, 0x9D, 0.2),
                    ),
                    child: isPortrait
                        ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    weatherInfo.date,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    '${temperature(weatherInfo.temperature)}$unitSymbol',
                                    style: const TextStyle(
                                      fontSize: 48,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    weatherInfo.time,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child:Transform.scale(
                                  scale: 1.5, // Set the desired zoom ratio
                                  child: Image.network(
                                    'https://openweathermap.org/img/wn/${weatherInfo.iconUrl}@4x.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                            ),
                          ],
                        )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                flex: 1,
                                child: Text(
                                  weatherInfo.date,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 1,
                                child: Text(
                                  weatherInfo.time,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 2,
                                child: Transform.scale(
                                  scale: 1.5, // Set the desired zoom ratio
                                  child: Image.network(
                                    'https://openweathermap.org/img/wn/${weatherInfo.iconUrl}@4x.png',
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                              Flexible(
                                flex: 3,
                                child: Text(
                                  '${temperature(weatherInfo.temperature)}$unitSymbol',
                                  style: const TextStyle(
                                    fontSize: 48,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
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
              return _loadingPage();
            }
          },
        ),
      ),
    );
  }

  Widget _loadingPage() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8),
        ),
        child: const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }
}
