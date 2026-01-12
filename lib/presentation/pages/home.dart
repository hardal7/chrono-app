import 'package:flutter/material.dart';

import '../style.dart';
import 'login.dart';
import 'tracker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  List<StatelessWidget> navigationPages = [
    TrackerPage(),
    LoginPage(),
    LoginPage(),
    LoginPage(),
    LoginPage(),
  ];
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.timer, color: accentColor),
            label: 'Tracker',
          ),
          NavigationDestination(
            icon: Icon(Icons.group, color: accentColor),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard, color: accentColor),
            label: 'Users',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: accentColor),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: accentColor),
            label: 'Settings',
          ),
        ],
        backgroundColor: backgroundColor,
        labelTextStyle: WidgetStatePropertyAll(
          TextStyle(color: accentColor),
        ),
        indicatorColor: accentColor.withValues(alpha: 0.3),
      ),
      body: navigationPages[_currentPageIndex],
    );
  }
}
