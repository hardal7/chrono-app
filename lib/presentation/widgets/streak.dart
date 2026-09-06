import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Streak extends StatelessWidget {
  const Streak({super.key, required this.streak});

  final int streak;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SvgPicture.asset('assets/icons/fire.svg', semanticsLabel: 'Fire Icon'),
        Positioned(
          top: 12,
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
