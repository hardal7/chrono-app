import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'presentation/pages/boarding.dart';
import 'package:flutter/material.dart';

import 'services/dio.dart';

Future<void> main() async {
  dotenv.load();
  initializeDio();
  runApp(const Chrono());
}

class Chrono extends StatelessWidget {
  const Chrono({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chrono',
      debugShowCheckedModeBanner: false,
      home: BoardingPage(),
    );
  }
}
