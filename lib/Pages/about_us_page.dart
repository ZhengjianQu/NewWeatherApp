import 'package:flutter/material.dart';

import '../global_variables.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                    margin: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20), // 设置圆角半径为10
                        color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)),
                    child: Container(
                      margin: const EdgeInsets.all(40),
                      child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.info,
                                  color: Colors.white70,
                                  size: 30,
                                ),
                                const SizedBox(width: 10),
                                createText('About Us', 24, color: Colors.white70)
                              ],
                            ),
                            const SizedBox(height: 40),
                            Expanded(
                              child: SingleChildScrollView(
                                child: createText(aboutUsText, 16, color: Colors.white70)
                              ),
                            ),
                            //createText(aboutUsText, 16, color: Colors.white70)
                          ]),
                    ))),
              ),
            ));
  }
}