import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_flutter_202210/pages/detail_page.dart';
import 'package:sample_flutter_202210/pages/home_page.dart';
import 'package:sample_flutter_202210/pages/settings_page.dart';

import 'components/bottom_navigation.dart';
import 'pages/search_page.dart';

final GlobalKey<NavigatorState> _sectionHomeNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionHomeNav');
final GlobalKey<NavigatorState> _sectionSearchNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionSearchNav');
final GlobalKey<NavigatorState> _sectionSettingNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'sectionSettingsNav');

class App extends StatelessWidget {
  App({super.key});

  static final List<ScaffoldWithNavBarTabItem> _tabs =
      <ScaffoldWithNavBarTabItem>[
    ScaffoldWithNavBarTabItem(
        rootRoutePath: '/home',
        navigatorKey: _sectionHomeNavigatorKey,
        icon: const Icon(Icons.home),
        label: 'Home'),
    ScaffoldWithNavBarTabItem(
      rootRoutePath: '/search',
      navigatorKey: _sectionSearchNavigatorKey,
      icon: const Icon(Icons.search),
      label: 'Search',
    ),
    ScaffoldWithNavBarTabItem(
      rootRoutePath: '/settings',
      navigatorKey: _sectionSettingNavigatorKey,
      icon: const Icon(Icons.settings),
      label: 'Settings',
    ),
  ];

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
    initialLocation: '/home',
    routes: <RouteBase>[
      BottomTabBarShellRoute(
        tabs: _tabs,
        routes: <RouteBase>[
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
    ],
  );
}
