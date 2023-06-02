import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_iffic/weather.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // 返回上一个页面
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(
              horizontal: 30, vertical: 30
          ), // 设置左右和上下的间距
          decoration: BoxDecoration(
              borderRadius:
              BorderRadius.circular(10), // 设置圆角半径为10
              color: const Color.fromRGBO(0x0, 0x0, 0x0, 0.8)
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => context.go('/emptypage'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.info,color: Colors.white),
                      Text('About US', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/emptypage'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.groups,color: Colors.white),
                      Text('Teams', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: () => context.go('/emptypage'),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.support_agent,color: Colors.white),
                      Text('Contact', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
