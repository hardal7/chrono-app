import 'package:flutter/material.dart';

import '../style.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;
  NavigationDestinationLabelBehavior labelBehavior =
      NavigationDestinationLabelBehavior.alwaysShow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: labelBehavior,
        selectedIndex: currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(Icons.group, color: foregroundColor),
            label: 'Sessions',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard, color: foregroundColor),
            label: 'Global',
          ),
          NavigationDestination(
            icon: Icon(Icons.person, color: foregroundColor),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings, color: foregroundColor),
            label: 'Settings',
          ),
        ],
        backgroundColor: backgroundColor,
        labelTextStyle: WidgetStatePropertyAll(bodySmall),
        indicatorColor: foregroundColor,
        animationDuration: const Duration(seconds: 1),
      ),
      body: Material(
        color: backgroundColor,
        child: Center(child: Text('Home', style: labelSmall)),
      ),
    );
  }
}
