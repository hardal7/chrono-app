import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/settings.dart';

class StatsSettingsPage extends StatelessWidget {
  const StatsSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Column(
            children: [SettingsButton(settingsPage: StatsSettingsPage())],
          ),
        );
      },
    );
  }
}
