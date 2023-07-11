import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ComponentLayout/web_view.dart';
import '../global_variables.dart';

class ApiKeyVerificationPage extends StatefulWidget {
  const ApiKeyVerificationPage({super.key});

  @override
  ApiKeyVerificationPageState createState() => ApiKeyVerificationPageState();
}

class ApiKeyVerificationPageState extends State<ApiKeyVerificationPage> {
  late TextEditingController _apiKeyController;
  String _verificationResult = '';

  @override
  void initState() {
    super.initState();
    _apiKeyController = TextEditingController();
  }



  Future<void> _verifyApiKey() async {
    final readApiKey = _apiKeyController.text;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?lat=60&lon=60&appid=$readApiKey&units=metric';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      apiKey = readApiKey;
      _saveApiKey();
      setState(() {
        _verificationResult = 'API Key is valid';
      });
    } else {
      setState(() {
        _verificationResult = 'API Key is invalid';
      });
    }
  }

  Future<void> _saveApiKey() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userApiKey', apiKey);
  }

  @override
  Widget build(BuildContext context) {

    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                      Icons.settings,
                      color: Colors.white70,
                      size: 30,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'API Setting',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(width: 60),
                  ]
                )
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
              margin: const EdgeInsets.all(30),
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _apiKeyController,
                    maxLines: isPortrait? 2:1,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      labelText: 'API Key',
                      labelStyle: const TextStyle(color: Colors.white70),
                      fillColor: Colors.black87,
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(child: SizedBox()),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const WebViewPage(url: 'https://openweathermap.org/api'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Get your own API',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _verifyApiKey,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                        ),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _verificationResult,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Enter your API Key and click "Verify" to check if it is valid. If the API Key is valid, it will be saved locally as userApiKey.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

  }
}

