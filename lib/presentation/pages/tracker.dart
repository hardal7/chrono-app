import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../handler/get_today.dart';
import '../../handler/get_topic.dart';
import '../../handler/track.dart';
import '../duration.dart';
import '../style.dart';
import 'package:flutter/material.dart';

import '../widgets/button.dart';
import '../widgets/settings.dart';

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
  late Timer uiTimer;
  late Timer topicTimer;
  late Duration duration;
  late String topicTime = '00:00';
  late String todayTime = '00:00';

  @override
  void initState() {
    super.initState();

    stopwatch = Stopwatch();
    duration = Duration();

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadTimes();
    });

    loadTimes();
  }

  Future<void> loadTimes() async {
    final secondsTopic = await getTopicTime('General');
    final secondsToday = await getTodayTime();

    if (!mounted) return;

    setState(() {
      if (secondsTopic != null) {
        topicTime = Duration(seconds: secondsTopic).toStopwatchString();
      }

      if (secondsToday != null) {
        todayTime = Duration(seconds: secondsToday).toStopwatchString();
      }
    });
  }

  @override
  void dispose() {
    uiTimer.cancel();
    topicTimer.cancel();
    stopwatch.stop();

    super.dispose();
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
                          const AssetImage('assets/icons/fire.png'),
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
                    Text('General', style: bodyLarge),

                    Icon(Icons.chevron_right, color: foregroundColor, size: 36),
                  ],
                ),
              ),
              Text('$topicTime overall', style: bodyLargeGrey),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageIcon(
                    const AssetImage('assets/icons/triangle.png'),
                    color: greenColor,
                  ),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(text: todayTime, style: bodyMediumGreen),
                        TextSpan(text: ' today', style: bodyMediumGrey),
                      ],
                    ),
                  ),
                ],
              ),
              TrackerStopwatch(
                height: height,
                stopwatch: stopwatch,
                onTimeChanged: loadTimes,
              ),
            ],
          ),
        );
      },
    );
  }
}

class TrackerStopwatch extends StatelessWidget {
  const TrackerStopwatch({
    super.key,
    required this.height,
    required this.stopwatch,
    required this.onTimeChanged,
  });

  final double height;
  final Stopwatch stopwatch;
  final Future<void> Function() onTimeChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height / 10),
          child: Text(stopwatch.elapsed.toStopwatchString(), style: bodyMax),
        ),

        Text('Count 1', style: bodyLargeGrey),

        Padding(
          padding: EdgeInsets.only(top: height / 10),
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
            size: const Size(175, 45),
            onPressed: () async {
              if (stopwatch.isRunning) {
                await stopTracker(stopwatch);
                await onTimeChanged();
              } else {
                startTracker(stopwatch);
              }
            },
          ),
        ),
      ],
    );
  }
}
