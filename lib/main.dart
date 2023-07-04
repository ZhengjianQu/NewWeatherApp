import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'Pages/about_us_page.dart';
import 'Pages/apikey_verification_page.dart';
import 'Pages/contact_page.dart';
import 'Pages/team_screen.dart';
import 'Pages/technologies_page.dart';
import 'Pages/weather_screen.dart';

void main(){
  // Set the system's navigation bar color to black
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black,
    ),
  );
  runApp(const MyApp());
}


/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        fontFamily: 'Agdasima',
      ),
      initialRoute: '/',
      routes:
      {
        '/': (context) => const WeatherPage(),
        '/team': (context) => const TeamPage(),
        '/about_us':(context) => const AboutUsPage(),
        '/technologies_page':(context) => const TechnologiesPage(),
        '/contact_page':(context) => const ContactPage(),
        '/api_page':(context) => const ApiKeyVerificationPage(),
      },
    );
  }
}






