import 'package:flutter/material.dart';

import '../style.dart';

class TodayTime extends StatelessWidget {
  const TodayTime({super.key, required this.todayTime});
  final String todayTime;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ImageIcon(
          const AssetImage('assets/icons/triangle.png'),
          color: greenColor,
        ),
        RichText(
          text: TextSpan(
            children: [
              TextSpan(text: todayTime, style: bodySmallGreen),
              TextSpan(text: ' today', style: bodySmallGrey),
            ],
          ),
        ),
      ],
    );
  }
}
