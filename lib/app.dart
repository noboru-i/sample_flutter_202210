import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_flutter_202210/pages/detail_page.dart';
import 'package:sample_flutter_202210/pages/home_page.dart';
import 'package:sample_flutter_202210/pages/scaffold_with_nav_bar.dart';
import 'package:sample_flutter_202210/pages/settings_page.dart';

import 'pages/search_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class App extends StatelessWidget {
  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routerConfig: _router,
    );
  }

  final GoRouter _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/home',
    routes: <RouteBase>[
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) => ScaffoldWithNavBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchPage(),
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) => const DetailPage(),
              )
            ],
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return const SearchPage();
        },
      ),
    ],
  );
}
