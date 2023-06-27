import 'package:flutter/material.dart';

import '../global_variables.dart';

class TechnologiesPage extends StatelessWidget {
  const TechnologiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    if(MediaQuery.of(context).orientation == Orientation.portrait){
      return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black.withOpacity(0.8),
              toolbarHeight: 50,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getBackgroundPath()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const Column(
                            children: [
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.extension,
                                    color: Colors.white70,
                                    size: 30,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    'Technologies',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 40),
                              Text(
                                'A weather app developed using Android Studio that fetches data from the OpenWeather API.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ]),
                      ))),
            ),
          ));
    }else{
      return MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.black.withOpacity(0.8),
              toolbarHeight: 50,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              title: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.extension,
                    color: Colors.white70,
                    size: 30,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Technologies',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  SizedBox(width: 60),
                ],
              ),
            ),
            body: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(getBackgroundPath()),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                  child: Container(
                      margin: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
                      child: Container(
                        margin: const EdgeInsets.all(20),
                        child: const Column(
                            children: [
                              Text(
                                'A weather app developed using Android Studio that fetches data from the OpenWeather API.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white70,
                                ),
                              ),
                            ]),
                      ))),
            ),
          ));
    }
  }
}