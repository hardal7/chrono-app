import 'dart:async';

import '../../handler/track.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/settings.dart';

TextStyle greyMedium = const TextStyle(
  color: secondaryColor,
  fontSize: 24,
  fontWeight: FontWeight.w500,
);

class TrackerSettingsPage extends StatelessWidget {
  const TrackerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  late Stopwatch stopwatch;
  late Timer timer;
  late Duration duration;

  @override
  void initState() {
    super.initState();
    stopwatch = Stopwatch();
    duration = Duration();

    timer = Timer.periodic(Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;
        return Material(
          color: backgroundColor,
          child: Column(
            children: [
              SettingsButton(settingsPage: TrackerSettingsPage()),
              Padding(
                padding: EdgeInsets.only(top: height / 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5.0,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ImageIcon(
                          AssetImage('assets/icons/fire.png'),
                          size: 32,
                          color: Colors.red,
                        ),
                        Positioned(
                          top: 10.0,
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: foregroundColor,
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Topic',
                      style: TextStyle(
                        color: foregroundColor,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Icon(Icons.chevron_right, color: foregroundColor, size: 36),
                  ],
                ),
              ),
              Text('307:52 overall', style: greyMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    AssetImage('assets/icons/triangle.png'),
                    color: greenColor,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '37:08',
                          style: TextStyle(
                            color: greenColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: ' today',
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: height / 10),
                child: Text(
                  stopwatch.elapsed.toStopwatchString(),
                  style: TextStyle(
                    color: foregroundColor,
                    fontSize: 84,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text('Count 1', style: greyMedium),
              Padding(
                padding: EdgeInsets.only(top: height / 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5.0,
                  children: [
                    Icon(Icons.circle, color: foregroundColor, size: 16.0),
                    Icon(Icons.circle, color: secondaryColor, size: 16.0),
                    Icon(Icons.circle, color: secondaryColor, size: 16.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: GenericButton(
                  text: stopwatch.isRunning ? 'Stop' : 'Start',
                  size: Size(175, 45),
                  onPressed: () {
                    if (stopwatch.isRunning) {
                      stopTracker(stopwatch);
                    } else {
                      startTracker(stopwatch);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

extension DurationFormatting on Duration {
  String toStopwatchString() {
    final hours = inHours;
    final minutes = inMinutes.remainder(60);
    final seconds = inSeconds.remainder(60);

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
