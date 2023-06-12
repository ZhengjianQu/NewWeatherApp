import 'package:flutter/material.dart';
import 'global_variables.dart';
import 'DataStructure/forecast_model.dart';



class Forecast extends StatefulWidget {
  final Future<ForecastData> forecastData;
  const Forecast({Key? key, required this.forecastData}) : super(key: key);

  @override
  ForecastState createState() => ForecastState();
}

class ForecastState extends State<Forecast> {
  late Future<ForecastData> forecastData;

  @override
  void initState() {
    super.initState();
    forecastData = Future<ForecastData>.value(widget.forecastData);
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
                    final forecastData = snapshot.data!;
                    final forecastList = forecastData.forecastListData;
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
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
