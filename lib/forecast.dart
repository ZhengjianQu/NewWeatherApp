import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

String apikey = '8dab3e149329990d1d9456befa085601';

class Forecast extends StatefulWidget {
  const Forecast({super.key});

  @override
  ForecastState createState() => ForecastState();
}

class ForecastState extends State<Forecast> {

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
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Forecast'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.go('/'),
            ),
          ),
        ),
      ),
    );
  }
}