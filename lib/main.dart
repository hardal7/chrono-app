import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'presentation/pages/boarding.dart';
import 'package:flutter/material.dart';

import 'presentation/pages/home.dart';
import 'presentation/style.dart';
import 'services/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/sqlite.dart';

late String username;

Future<void> main() async {
  await dotenv.load();
  await initializeDio();

  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username') ?? '';
  debugPrint('Username: $username');

  syncEvents();
  runApp(const Chrono());
}

class Chrono extends StatefulWidget {
  const Chrono({super.key});

  @override
  State<Chrono> createState() => _ChronoState();
}

class _ChronoState extends State<Chrono> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: themeNotifier,
      builder: (context, theme, child) {
        return MaterialApp(
          title: 'Chrono',
          debugShowCheckedModeBanner: false,
          theme: theme,
          // home: username == '' ? BoardingPage() : HomePage(),
          home: BoardingPage(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: _locales,
        );
      },
    );
  }
}

List<Locale> _locales = [Locale('en'), Locale('tr')];
