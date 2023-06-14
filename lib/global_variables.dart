import 'package:flutter/material.dart';

String apiKey = '8dab3e149329990d1d9456befa085601';
String weather = 'Clear';
bool isCelsius = true;
String unitSymbol = "°C";
double latitude = 0.0;
double longitude = 0.0;
String location = "";

void setPosition(double lat,double lon){
  latitude = lat;
  longitude = lon;
}

String getBackgroundPath(){
  return "assets/images/Backgrounds/$weather.png";
}

Widget createText(String text, double fontSize, {Color? color}) {
  return Text(
    text,
    style: TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: color ?? Colors.white,
    ),
  );
}

final List groupMembers = [
  ['Zhengjian Qu', 'APP Developer', 'zhengjian.qu@ue-germany.de'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
  ['Name', 'APP Developer', 'email@example.com'],
];

String aboutUsText =
'''
Welcome to our team at Tempo . We are a dedicated team of Developers and Designers that aim to bring the best user experience to customers like you so that you can access accurate and real-time information right at your fingertips. We started off as a group of University students that eventually took our passion for technology and established our company. Now , we are a small but talented team of 11 creative minds , and with a deep understanding of meteorology and cutting-edge technology, we continue to deliver a seamless user experience and constantly work on your feedback to continuously improve our app performance and your happiness. Our team's expertise lies in designing and maintaining functional and user friendly interface and accurate real time data analysis . Weather and Weather forecasts are among the few factors that impact our daily lives, so it is important that this data is accessible in the utmost accurate and comprehensible format , so that you can make informed decisions about your day. We hope that we at Tempo can provide you with the best user experience.
''';

String technologiesText =
'''
A weather app developed using Android Studio that fetches data from the OpenWeather API.
''';