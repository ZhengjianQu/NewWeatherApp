import 'package:flutter/material.dart';
import 'package:weather_iffic/Pages/weather_screen.dart';

import '../global_variables.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final TextEditingController _textField1Controller = TextEditingController();
  final TextEditingController _textField2Controller = TextEditingController();
  final TextEditingController _textField3Controller = TextEditingController();

  @override
  void dispose() {
    _textField1Controller.dispose();
    _textField2Controller.dispose();
    _textField3Controller.dispose();
    super.dispose();
  }

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
                borderRadius: BorderRadius.circular(20),
                color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8),
              ),
              child: Container(
                margin: const EdgeInsets.all(30),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.contact_support,
                          color: Colors.white70,
                          size: 30,
                        ),
                        const SizedBox(width: 10),
                        createText('Contact', 24, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 30),
                    buildInputField('Name', _textField1Controller),
                    const SizedBox(height: 10),
                    buildInputField('Email', _textField2Controller),
                    const SizedBox(height: 10),
                    buildInputField('Message', _textField3Controller, maxLines: 3),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // TODO: Contact Function
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8),
                      ),
                      child: 
                      createText('Contact Us', 16, color: Colors.white70)
                    ),
                    const SizedBox(height: 10),
                    createText('If you have any questions or problems, please feel free to contact us.', 12, color: Colors.white70),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: SizedBox(
                          child: Image.asset(
                            'assets/images/Photos/Contact_Cut.jpg',
                            fit: BoxFit.contain,
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

  Widget buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        fillColor: Colors.black87,
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

class BottomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 20); // 设置剪裁的高度
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}