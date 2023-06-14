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
                createListTile('About Us', Icons.info, '/about_us', context),
                createListTile('Team', Icons.group, '/team', context),
                createListTile('Technologies', Icons.extension, '/technologies_page', context),
                createListTile('Contact', Icons.contact_support, '/contact_page', context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget createListTile(String text, IconData icon, String path, BuildContext context) {
  return ListTile(
    title:

    Text(
      text,
      style: TextStyle(color: Colors.white.withOpacity(0.5)),
    ),
    leading: Icon(icon, color: Colors.white.withOpacity(0.5)),
    onTap: () {
      Navigator.of(context).pop();
      Navigator.pushNamed(context, path);
    },
  );
}