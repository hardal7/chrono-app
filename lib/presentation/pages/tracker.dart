import 'dart:async';
import 'dart:io';
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

Future<void> loadTimes(String topic, Times times) async {
  final (secondsTopic, streak) = await getTopic(topic);
  final secondsToday = await getTopicTimeToday();

  if (secondsTopic != null) {
    times.topicTime = Duration(seconds: secondsTopic).toStopwatchString();
  }
  if (secondsToday != null) {
    times.todayTime = Duration(seconds: secondsToday).toStopwatchString();
  }
}

class Times {
  Times({this.topicTime, this.todayTime});
  String? topicTime;
  String? todayTime;
}

ValueNotifier<Times> times = ValueNotifier(
  Times(topicTime: '00:00', todayTime: '00:00'),
);

class _TrackerPageState extends State<TrackerPage> {
  final trackerController = PageController();
  late Stopwatch stopwatch;
  late Timer uiTimer;
  late Timer topicTimer;
  late Duration duration;
  String setTopic = 'General';
  // TODO: Return streak
  int streak = 0;

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
      await loadTimes(setTopic, times.value);
    });
    loadTimes(setTopic, times.value);
  }

  @override
  void dispose() {
    uiTimer.cancel();
    topicTimer.cancel();
    trackerController.dispose();
    stopwatch.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return ValueListenableBuilder<Times>(
          valueListenable: times,
          builder: (context, value, child) {
            return Material(
              color: backgroundColor,
              child: Column(
                children: [
                  SettingsButton(settingsPage: TrackerSettingsPage()),
                  Padding(
                    padding: EdgeInsets.only(top: height / 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      spacing: 5.0,
                      children: [
                        if (streak != 0)
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
                                  '$streak',
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
                        Icon(
                          Icons.chevron_right,
                          color: foregroundColor,
                          size: 36,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${times.value.topicTime} overall',
                    style: bodyLargeGrey,
                  ),
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
                            TextSpan(
                              text: times.value.todayTime,
                              style: bodyMediumGreen,
                            ),
                            TextSpan(text: ' today', style: bodyMediumGrey),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height / 2.5,
                    child: PageView.builder(
                      controller: trackerController,
                      itemBuilder: (_, index) {
                        return switch (index) {
                          0 => TrackerStopwatch(
                            height: height,
                            stopwatch: stopwatch,
                            topic: setTopic,
                          ),
                          1 => TrackerTimer(
                            height: height,
                            stopwatch: stopwatch,
                            topic: setTopic,
                            timer: Duration(minutes: 25),
                          ),
                          _ => const SizedBox.shrink(),
                        };
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: height / 20),
                    child: SmoothPageIndicator(
                      controller: trackerController,
                      count: 3,
                      effect: WormEffect(
                        dotHeight: 18,
                        dotWidth: 18,
                        type: WormType.thin,
                        dotColor: secondaryColor,
                        activeDotColor: foregroundColor,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
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
    required this.topic,
  });

  final double height;
  final Stopwatch stopwatch;
  final String topic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height / 12),
          child: Text(stopwatch.elapsed.toStopwatchString(), style: bodyMax),
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: GenericButton(
            text: stopwatch.isRunning ? 'Stop' : 'Start',
            size: const Size(175, 45),
            onPressed: () async {
              if (stopwatch.isRunning) {
                await stopTracker(stopwatch);
                await loadTimes(topic, times.value);
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

class TrackerTimer extends StatelessWidget {
  const TrackerTimer({
    super.key,
    required this.height,
    required this.stopwatch,
    required this.topic,
    required this.timer,
  });

  final double height;
  final Stopwatch stopwatch;
  final String topic;
  final Duration timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height / 12),
          child: Text(
            (timer - stopwatch.elapsed).toStopwatchString(),
            style: bodyMax,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: GenericButton(
            text: stopwatch.isRunning ? 'Stop' : 'Start',
            size: const Size(175, 45),
            onPressed: () async {
              if (stopwatch.isRunning) {
                await stopTracker(stopwatch);
                await loadTimes(topic, times.value);
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
