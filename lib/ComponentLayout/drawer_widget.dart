import 'package:flutter/material.dart';
import '../global_variables.dart';

class DrawerWidget extends StatelessWidget {
  final padding = const EdgeInsets.symmetric(horizontal: 20);

  const DrawerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(getBackgroundPath()),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(0.75),
          ),
          Center(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 60),
              children: [
                const SizedBox(height: 150),
                ListTile(
                  title:
                  const Text(
                    'About Us',
                    style: TextStyle(color: Colors.white60),
                  ),
                  leading: const Icon(Icons.info, color: Colors.white60),
                  onTap: () {
                    modifiable = false;
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/about_us');
                  },
                ),
                ListTile(
                  title:
                  const Text(
                    'Team',
                    style: TextStyle(color: Colors.white60),
                  ),
                  leading: const Icon(Icons.group, color: Colors.white60),
                  onTap: () {
                    modifiable = false;
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/team');
                  },
                ),
                ListTile(
                  title:
                  const Text(
                    'Technologies',
                    style: TextStyle(color: Colors.white60),
                  ),
                  leading: const Icon(Icons.extension, color: Colors.white60),
                  onTap: () {
                    modifiable = false;
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/technologies_page');
                  },
                ),
                ListTile(
                  title:
                  const Text(
                    'Contact Us',
                    style: TextStyle(color: Colors.white60),
                  ),
                  leading: const Icon(Icons.contact_support, color: Colors.white60),
                  onTap: () {
                    modifiable = false;
                    Navigator.of(context).pop();
                    Navigator.pushNamed(context, '/contact_page');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}