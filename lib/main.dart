import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'handler/user.dart';
import 'l10n/app_localizations.dart';
import 'outbox/sqlite.dart';
import 'outbox/sync.dart';
import 'presentation/pages/boarding.dart';
import 'package:flutter/material.dart';

import 'services/app.dart';
import 'services/app_link.dart';
import 'services/cookie/cookie_init.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'services/dio.dart';

List<Locale> _locales = [Locale('en'), Locale('tr')];

Future<void> main() async {
  await dotenv.load();
  await initDioIntercept();
  await initCookieJar();
  await initLocalDB();

  syncEvents();

  // Timer.periodic(const Duration(minutes: 1), (_) async {
  // updateActivity();
  // });

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
    initLinkHandler(context);

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
