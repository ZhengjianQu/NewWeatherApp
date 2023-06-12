import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'emptypage.dart';
import 'menu.dart';
import 'combined.dart';

void main() => runApp(const MyApp());

final GoRouter _router = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const CombinedPage();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'menu',
          builder: (BuildContext context, GoRouterState state) {
            return const Menu();
          },
        ),
        GoRoute(
          path: 'emptypage',
          builder: (BuildContext context, GoRouterState state) {
            return const EmptyPage();
          },
        ),
      ],
    ),
  ],
);

/// The main app.
class MyApp extends StatelessWidget {
  /// Constructs a [MyApp]
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
    );
  }
}






