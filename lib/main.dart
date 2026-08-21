import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/pages/boarding.dart';
import 'package:flutter/material.dart';

import 'presentation/pages/home.dart';
import 'services/dio.dart';

late String username;

Future<void> main() async {
  await dotenv.load();
  await initializeDio();

  final prefs = await SharedPreferences.getInstance();
  username = prefs.getString('username') ?? '';
  debugPrint('Username: $username');

  runApp(const Chrono());
}

class Chrono extends StatelessWidget {
  const Chrono({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono',
      debugShowCheckedModeBanner: false,
      home: username == '' ? BoardingPage() : HomePage(),
    );
  }
}
