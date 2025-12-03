import 'package:flutter/material.dart';
import 'package:study_app/features/user/boarding.dart';

void main() {
  runApp(const StudyApp());
}

class StudyApp extends StatelessWidget {
  const StudyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Study App',
      debugShowCheckedModeBanner: false,
      home: BoardingPage(),
    );
  }
}
