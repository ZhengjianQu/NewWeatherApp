import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_iffic/weather.dart';
import 'package:weather_iffic/forecast.dart';

String apikey = '8dab3e149329990d1d9456befa085601';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const WeatherApp();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'forecast',
          builder: (BuildContext context, GoRouterState state) {
            return const Forecast();
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}






