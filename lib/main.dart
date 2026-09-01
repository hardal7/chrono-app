import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'outbox/outbox.dart';
import 'presentation/pages/boarding.dart';
import 'package:flutter/material.dart';

import 'presentation/pages/home.dart';
import 'presentation/style.dart';
import 'services/dio.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

late String username;
List<Locale> _locales = [Locale('en'), Locale('tr')];

class AppValues {
  AppValues({required this.locale, required this.theme});
  Locale locale;
  ThemeData theme;
}

ValueNotifier<AppValues> appNotifier = ValueNotifier(
  AppValues(theme: darkTheme, locale: Locale('en')),
);

Future<void> main() async {
  await dotenv.load();
  await initializeDio();
  await initializeLocalDB();

  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username') ?? '';

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
    return ValueListenableBuilder<AppValues>(
      valueListenable: appNotifier,
      builder: (context, app, child) {
        return MaterialApp(
          title: 'Chrono',
          debugShowCheckedModeBanner: false,
          theme: app.theme,
          // home: username == '' ? BoardingPage() : HomePage(),
          home: BoardingPage(),
          localizationsDelegates: [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: _locales,
          locale: app.locale,
        );
      },
    );
  }
}
