import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../style.dart';
import 'profile.dart';
import 'sessions.dart';
import 'settings.dart';
import 'tracker.dart';
import 'users.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  late String username;

  List<Widget> get navigationPages => [
    TrackerPage(),
    SessionsPage(),
    UsersPage(),
    ProfilePage(username: username),
    SettingsPage(),
  ];
  List<Widget> destinations = [
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
  ];

  Future<void> loadUsername() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      username = prefs.getString('username') ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    loadUsername();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: destinations,
        backgroundColor: backgroundColor,
        labelTextStyle: WidgetStatePropertyAll(TextStyle(color: accentColor)),
        indicatorColor: accentColor.withValues(alpha: 0.3),
      ),
      body: navigationPages[_currentPageIndex],
    );
  }
}
