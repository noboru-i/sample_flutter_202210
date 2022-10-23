import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sample_flutter_202210/pages/detail_page.dart';
import 'package:sample_flutter_202210/pages/home_page.dart';
import 'package:sample_flutter_202210/pages/settings_page.dart';

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

// use https://gist.github.com/tolo/f7e6c30cad3ac76085d75255ba509f10

class ScaffoldWithNavBarTabItem extends BottomNavigationBarItem {
  const ScaffoldWithNavBarTabItem({
    required this.rootRoutePath,
    required this.navigatorKey,
    required Widget icon,
    required String label,
  }) : super(
          icon: icon,
          label: label,
        );

  final String rootRoutePath;
  final GlobalKey<NavigatorState> navigatorKey;
}

class BottomTabBarShellRoute extends ShellRoute {
  final List<ScaffoldWithNavBarTabItem> tabs;

  BottomTabBarShellRoute({
    required this.tabs,
    required List<RouteBase> routes,
  }) : super(
          routes: routes,
          builder: (context, state, Widget fauxNav) {
            return Stack(
              children: [
                // Needed to keep the (faux) shell navigator alive
                Offstage(child: fauxNav),
                ScaffoldWithNavBar(
                  tabs: tabs,
                  currentNavigator: fauxNav as Navigator,
                  currentRouterState: state,
                  routes: routes,
                ),
              ],
            );
          },
        );
}

class ScaffoldWithNavBar extends StatefulWidget {
  const ScaffoldWithNavBar({
    required this.currentNavigator,
    required this.currentRouterState,
    required this.tabs,
    required this.routes,
    Key? key,
  }) : super(key: key ?? const ValueKey<String>('ScaffoldWithNavBar'));

  final Navigator currentNavigator;
  final GoRouterState currentRouterState;
  final List<ScaffoldWithNavBarTabItem> tabs;
  final List<RouteBase> routes;

  List<Page<dynamic>> get pagesForCurrentRoute => currentNavigator.pages;

  @override
  State<StatefulWidget> createState() => ScaffoldWithNavBarState();
}

class ScaffoldWithNavBarState extends State<ScaffoldWithNavBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final List<_NavBarTabNavigator> _tabs;

  int _locationToTabIndex(String location) {
    final int index = _tabs.indexWhere(
        (_NavBarTabNavigator t) => location.startsWith(t.rootRoutePath));
    return index < 0 ? 0 : index;
  }

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = widget.tabs
        .map((ScaffoldWithNavBarTabItem e) => _NavBarTabNavigator(e))
        .toList();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant ScaffoldWithNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateForCurrentTab();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateForCurrentTab();
  }

  void _updateForCurrentTab() {
    final int previousIndex = _currentIndex;
    final location = GoRouter.of(context).location;
    _currentIndex = _locationToTabIndex(location);

    final _NavBarTabNavigator tabNav = _tabs[_currentIndex];
    tabNav.pages = widget.pagesForCurrentRoute;
    tabNav.lastLocation = location;

    if (previousIndex != _currentIndex) {
      _animationController.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
      bottomNavigationBar: BottomNavigationBar(
        items: _tabs
            .map((_NavBarTabNavigator e) => e.bottomNavigationTab)
            .toList(),
        currentIndex: _currentIndex,
        onTap: (int idx) => _onItemTapped(idx, context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FadeTransition(
        opacity: _animationController,
        child: IndexedStack(
            index: _currentIndex,
            children: _tabs
                .map((_NavBarTabNavigator tab) => tab.buildNavigator(context))
                .toList()));
  }

  void _onItemTapped(int index, BuildContext context) {
    GoRouter.of(context).go(_tabs[index].currentLocation);
  }
}

class _NavBarTabNavigator {
  _NavBarTabNavigator(this.bottomNavigationTab);

  final ScaffoldWithNavBarTabItem bottomNavigationTab;

  String? lastLocation;

  String get currentLocation =>
      lastLocation != null ? lastLocation! : rootRoutePath;

  String get rootRoutePath => bottomNavigationTab.rootRoutePath;
  Key get navigatorKey => bottomNavigationTab.navigatorKey;
  List<Page<dynamic>> pages = <Page<dynamic>>[];

  Widget buildNavigator(BuildContext context) {
    if (pages.isNotEmpty) {
      return Navigator(
        key: navigatorKey,
        pages: pages,
        onPopPage: (Route<dynamic> route, dynamic result) {
          if (pages.length == 1 || !route.didPop(result)) {
            return false;
          }
          GoRouter.of(context).pop();
          return true;
        },
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
