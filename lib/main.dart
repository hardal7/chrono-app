import 'package:flutter/material.dart';
import 'package:chrono/features/user/boarding.dart';

void main() {
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
