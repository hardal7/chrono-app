import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<NavigationDestination> destinations(Color color) {
    return [
      NavigationDestination(
        icon: Icon(Icons.timer, color: color),
        label: 'Tracker',
      ),
      NavigationDestination(
        icon: Icon(Icons.group, color: color),
        label: 'Sessions',
      ),
      NavigationDestination(
        icon: Icon(Icons.leaderboard, color: color),
        label: 'Users',
      ),
      NavigationDestination(
        icon: Icon(Icons.person, color: color),
        label: 'Profile',
      ),
      NavigationDestination(
        icon: Icon(Icons.settings, color: color),
        label: 'Settings',
      ),
    ];
  }

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
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      bottomNavigationBar: NavigationBar(
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(color: colors.primary),
        ),
        indicatorColor: colors.primary.withValues(alpha: 0.3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        selectedIndex: _currentPageIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentPageIndex = index;
          });
        },
        destinations: destinations(colors.primary),
      ),
      body: navigationPages[_currentPageIndex],
    );
  }
}
