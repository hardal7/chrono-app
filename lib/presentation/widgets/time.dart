import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../duration.dart';
import '../style.dart';

class TodayTime extends StatelessWidget {
  const TodayTime({super.key, required this.todayTime});
  final int todayTime;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

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
              TextSpan(
                text: Duration(seconds: todayTime).toStopwatchString(),
                style: bodyMedium.copyWith(color: greenColor),
              ),
              TextSpan(
                text: ' ${l10n.today}',
                style: bodySmall.copyWith(color: colors.secondary),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
