import 'package:flutter/material.dart';
import 'package:weather_iffic/Pages/weather_screen.dart';

import '../global_variables.dart';

class TeamPage extends StatelessWidget {

  const TeamPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Colors.black.withOpacity(0.8),
            toolbarHeight: 50,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WeatherPage()));
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
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // 设置圆角半径为10
                        color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      child: Column(
                          children: [
                            const SizedBox(height: 10),
                            const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.info,
                                  color: Colors.white70,
                                  size: 30,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  'About Us',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Expanded(
                              child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: groupMembers.length,
                                itemBuilder: (BuildContext context, int index) {
                                  List<String> memberInfo = groupMembers[index];
                                  return createBusinessCard(
                                      memberInfo[0],//name
                                      memberInfo[1],//role
                                      memberInfo[2],//email
                                  );
                                },
                              ),
                            ),
                          ]),
                    ))),
          ),
        ));
  }
}


Widget createBusinessCard(String name, String role, String email) {
  return Container(
    margin: const EdgeInsets.all(5),
    decoration: BoxDecoration(
      color: const Color.fromRGBO(
        0x48, 0x31, 0x9D, 0.2),
      borderRadius: BorderRadius.circular(20),
    ),

    child: Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/Photos/$name.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    role,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Text(
          email,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 5),
      ],
    ),
  );
}