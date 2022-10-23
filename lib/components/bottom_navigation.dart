import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
                _ScaffoldWithNavBar(
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

class _ScaffoldWithNavBar extends StatefulWidget {
  const _ScaffoldWithNavBar({
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
  State<StatefulWidget> createState() => _ScaffoldWithNavBarState();
}

class _ScaffoldWithNavBarState extends State<_ScaffoldWithNavBar>
    with SingleTickerProviderStateMixin {
  late final List<_NavBarTabNavigator> _tabs;

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabs = widget.tabs
        .map((ScaffoldWithNavBarTabItem e) => _NavBarTabNavigator(e))
        .toList();
  }

  @override
  void didUpdateWidget(covariant _ScaffoldWithNavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateForCurrentTab();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateForCurrentTab();
  }

  void _updateForCurrentTab() {
    final location = GoRouter.of(context).location;
    _currentIndex = _locationToTabIndex(location);

    final _NavBarTabNavigator tabNav = _tabs[_currentIndex];
    tabNav.pages = widget.pagesForCurrentRoute;
    tabNav.lastLocation = location;
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
        unselectedFontSize: 12,
        selectedFontSize: 12,
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return IndexedStack(
      index: _currentIndex,
      children: _tabs
          .map((_NavBarTabNavigator tab) => tab.buildNavigator(context))
          .toList(),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    GoRouter.of(context).go(_tabs[index].currentLocation);
  }

  int _locationToTabIndex(String location) {
    final int index = _tabs.indexWhere(
        (_NavBarTabNavigator t) => location.startsWith(t.rootRoutePath));
    return index < 0 ? 0 : index;
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
