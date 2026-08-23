import 'package:flutter/material.dart';

import '../style.dart';

class Streak extends StatelessWidget {
  const Streak({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset('assets/icons/fire.png'),
        Positioned(
          top: 15,
          child: Text(
            '$streak',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
