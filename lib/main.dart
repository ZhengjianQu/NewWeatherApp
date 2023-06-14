import 'package:flutter/material.dart';
import 'Pages/about_us_page.dart';
import 'Pages/contact_page.dart';
import 'Pages/team_screen.dart';
import 'Pages/technologies_page.dart';
import 'Pages/weather_screen.dart';

void main() => runApp(const MyApp());


/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes:
      {
        '/': (context) => const WeatherPage(),
        '/team': (context) => const TeamPage(),
        '/about_us':(context) => const AboutUsPage(),
        '/technologies_page':(context) => const TechnologiesPage(),
        '/contact_page':(context) => const ContactPage(),
      },
    );
  }
}






