import 'dart:async';

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../handler/all_topics.dart';
import '../../handler/today_time.dart';
import '../../handler/topic_time.dart';
import '../../handler/track.dart';
import '../duration.dart';
import '../style.dart';
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

Future<void> loadTimes(Tracker tracker) async {
  final (secondsTopic, streak) = await getTopicTime(tracker.topicName);
  final secondsToday = await getTopicTimeToday();

  if (secondsTopic != null) {
    tracker.topicTime = Duration(seconds: secondsTopic).toStopwatchString();
  }
  if (secondsToday != null) {
    tracker.todayTime = Duration(seconds: secondsToday).toStopwatchString();
  }
}

class Tracker {
  Tracker({
    required this.topicName,
    required this.topicTime,
    required this.todayTime,
    required this.streak,
  });
  String topicName;
  String topicTime;
  String todayTime;
  int streak;
}

ValueNotifier<Tracker> tracker = ValueNotifier(
  Tracker(
    topicName: 'General',
    topicTime: Duration.zero.toStopwatchString(),
    todayTime: Duration.zero.toStopwatchString(),
    streak: 0,
  ),
);

List<Topic> topics = List.empty();
bool showDropdown = false;

class _TrackerPageState extends State<TrackerPage> {
  final trackerController = PageController();
  late Stopwatch stopwatch;
  late Timer uiTimer;
  late Timer topicTimer;

  Future<void> _loadTopics() async {
    topics = await getAllTopics();
  }

  @override
  void initState() {
    super.initState();

    stopwatch = Stopwatch();

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadTimes(tracker.value);
    });

    loadTimes(tracker.value);
    _loadTopics();
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

        return ValueListenableBuilder<Tracker>(
          valueListenable: tracker,
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
                        if (tracker.value.streak != 0)
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
                                  '${tracker.value.streak}',
                                  style: TextStyle(
                                    color: foregroundColor,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              showDropdown = !showDropdown;
                            });
                          },
                          child: Row(
                            children: [
                              Text(tracker.value.topicName, style: bodyLarge),
                              Icon(
                                Icons.chevron_right,
                                color: foregroundColor,
                                size: 36,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: height / 8,
                    child: showDropdown
                        ? TopicDropdown(height: height)
                        : Column(
                            children: [
                              Text(
                                '${tracker.value.topicTime} overall',
                                style: bodyLargeGrey,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ImageIcon(
                                    const AssetImage(
                                      'assets/icons/triangle.png',
                                    ),
                                    color: greenColor,
                                  ),
                                  RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: tracker.value.todayTime,
                                          style: bodyMediumGreen,
                                        ),
                                        TextSpan(
                                          text: ' today',
                                          style: bodyMediumGrey,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
                            topic: tracker.value.topicName,
                          ),
                          1 => TrackerTimer(
                            height: height,
                            stopwatch: stopwatch,
                            topic: tracker.value.topicName,
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
                await loadTimes(tracker.value);
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
                await loadTimes(tracker.value);
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

class TopicDropdown extends StatefulWidget {
  const TopicDropdown({super.key, required this.height});
  final double height;

  @override
  State<TopicDropdown> createState() => _TopicDropdownState();
}

class _TopicDropdownState extends State<TopicDropdown> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: topics.map((topic) {
          return GestureDetector(
            onTap: () {
              tracker.value.topicName = topic.name;
              showDropdown = false;
            },
            child: topic.name != tracker.value.topicName
                ? Text(
                    '${topic.name}: ${Duration(seconds: topic.time).toHoursString()}',
                    style: bodyMediumGrey,
                  )
                : SizedBox.shrink(),
          );
        }).toList(),
      ),
    );
  }
}
