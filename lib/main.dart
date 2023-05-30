import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_iffic/weather.dart';
import 'package:weather_iffic/forecast.dart';
import 'package:weather_iffic/emptypage.dart';
import 'package:weather_iffic/menu.dart';

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
        GoRoute(
          path: 'menu',
          builder: (BuildContext context, GoRouterState state) {
            return const Menu();
          },
        ),
        GoRoute(
          path: 'emptypage',
          builder: (BuildContext context, GoRouterState state) {
            return const EmptyPage();
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






