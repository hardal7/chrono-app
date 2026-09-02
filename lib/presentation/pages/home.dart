import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../l10n/app_localizations.dart';
import '../style.dart';
import 'profile.dart';
import 'sessions_list.dart';
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

  List<Widget> get navigationPages => [
    TrackerPage(),
    SessionsListPage(),
    UsersPage(),
    ProfilePage(username: username),
    SettingsPage(),
  ];
  List<NavigationDestination> destinations(BuildContext context, Color color) {
    final l10n = AppLocalizations.of(context)!;

    return [
      NavigationDestination(
        icon: Icon(Icons.timer, color: color),
        label: l10n.tracker,
      ),
      NavigationDestination(
        icon: Icon(Icons.group, color: color),
        label: l10n.sessions,
      ),
      NavigationDestination(
        icon: Icon(Icons.leaderboard, color: color),
        label: l10n.users,
      ),
      NavigationDestination(
        icon: Icon(Icons.person, color: color),
        label: l10n.profile,
      ),
      NavigationDestination(
        icon: Icon(Icons.settings, color: color),
        label: l10n.settings,
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
        destinations: destinations(context, colors.primary),
      ),
      body: navigationPages[_currentPageIndex],
    );
  }
}
