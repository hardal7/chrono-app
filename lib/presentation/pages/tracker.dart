import 'dart:async';

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
  late String topicTotalTime = '0';
  late String todayTime = '0';

  @override
  void initState() {
    super.initState();

    stopwatch = Stopwatch();
    duration = Duration();

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {});
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      _loadTimes();
    });

    _loadTimes();
  }

  Future<void> _loadTimes() async {
    final secondsTopic = await getTopicTime('General');
    final secondsToday = await getTodayTime();

    setState(() {
      if (secondsTopic != null) {
        topicTotalTime = Duration(seconds: secondsTopic).toStopwatchString();
      }
      if (secondsToday != null) {
        todayTime = Duration(seconds: secondsToday).toStopwatchString();
      }
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
                padding: EdgeInsets.only(top: 20),
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
                      'General',
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
              Text('$topicTotalTime overall', style: labelLargeGrey),
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
                        TextSpan(text: '$todayTime', style: labelMediumGreen),
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
              Text('Count 1', style: labelLargeGrey),
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
                      _loadTimes();
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
