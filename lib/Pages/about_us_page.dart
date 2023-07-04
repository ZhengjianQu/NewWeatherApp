import 'package:flutter/material.dart';

import '../global_variables.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({Key? key});

  @override
  Widget build(BuildContext context) {

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 50,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white70),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, '/');
            },
          ),
          title: isPortrait
              ? null
              : const Row(
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
              margin: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8),
              ),
              child: Container(
                margin: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    if (isPortrait)
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
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Text(
                          'Welcome to our team at Tempo. We are a dedicated team of Developers and Designers that aim to bring the best user experience to customers like you so that you can access accurate and real-time information right at your fingertips. We started off as a group of University students that eventually took our passion for technology and established our company. Now, we are a small but talented team of 11 creative minds, and with a deep understanding of meteorology and cutting-edge technology, we continue to deliver a seamless user experience and constantly work on your feedback to continuously improve our app performance and your happiness. Our team\'s expertise lies in designing and maintaining functional and user-friendly interface and accurate real-time data analysis. Weather and Weather forecasts are among the few factors that impact our daily lives, so it is important that this data is accessible in the utmost accurate and comprehensible format, so that you can make informed decisions about your day. We hope that we at Tempo can provide you with the best user experience.',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
