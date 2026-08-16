import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../handler/all_topics.dart';
import '../../handler/create_topic.dart';
import '../../handler/today_time.dart';
import '../../handler/topic_time.dart';
import '../../handler/track.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import '../widgets/time.dart';

class TrackerSettingsPage extends StatelessWidget {
  const TrackerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

Future<void> loadTimes(TrackerValues tracker) async {
  final (secondsTopic, streak) = await getTopicTime(tracker.topicName);
  final secondsToday = await getTimeToday(topic: tracker.topicName);

  if (secondsTopic != null) {
    tracker.topicTime = Duration(seconds: secondsTopic).toStopwatchString();
  }
  if (secondsToday != null) {
    tracker.todayTime = Duration(seconds: secondsToday).toStopwatchString();
  }
}

class TrackerValues {
  TrackerValues({
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

ValueNotifier<TrackerValues> tracker = ValueNotifier(
  TrackerValues(
    topicName: 'General',
    topicTime: Duration.zero.toStopwatchString(),
    todayTime: Duration.zero.toStopwatchString(),
    streak: 0,
  ),
);

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final trackerController = PageController();
  late Stopwatch timer = Stopwatch();
  late Stopwatch stopwatch = Stopwatch();
  late Timer uiTimer;
  late Timer topicTimer;

  @override
  void initState() {
    super.initState();

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {});
      }
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadTimes(tracker.value);
    });

    loadTimes(tracker.value);
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

        return ValueListenableBuilder<TrackerValues>(
          valueListenable: tracker,
          builder: (context, value, child) {
            return Material(
              color: backgroundColor,
              child: Padding(
                padding: pageInset,
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
                                Text(
                                  tracker.value.topicName,
                                  style: bodyLarge,
                                  maxLines: 1,
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    left: showDropdown ? 5 : 0,
                                  ),
                                  child: Icon(
                                    showDropdown
                                        ? CupertinoIcons.chevron_down
                                        : Icons.chevron_right,
                                    color: foregroundColor,
                                    size: showDropdown ? 32 : 40,
                                    fontWeight: FontWeight(
                                      showDropdown ? 900 : 100,
                                    ),
                                  ),
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
                                  style: bodyMediumGrey,
                                ),
                                TodayTime(todayTime: tracker.value.todayTime),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: height / 2.5,
                      child: PageView.builder(
                        itemCount: 2,
                        controller: trackerController,
                        itemBuilder: (_, index) {
                          return switch (index) {
                            0 => Tracker(
                              height: height,
                              stopwatch: stopwatch,
                              topic: tracker.value.topicName,
                            ),
                            1 => Tracker(
                              height: height,
                              stopwatch: timer,
                              topic: tracker.value.topicName,
                              isStopwatch: false,
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
                        count: 2,
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
              ),
            );
          },
        );
      },
    );
  }
}

class Tracker extends StatelessWidget {
  const Tracker({
    super.key,
    required this.height,
    required this.stopwatch,
    required this.topic,
    this.isStopwatch = true,
    this.timer = const Duration(minutes: 25),
  });

  final double height;
  final Stopwatch stopwatch;
  final String topic;
  final bool isStopwatch;
  final Duration timer;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: height / 12),
          child: Text(
            (isStopwatch ? (timer - stopwatch.elapsed) : stopwatch.elapsed)
                .toStopwatchString(),
            style: bodyMax,
          ),
        ),

        Padding(
          padding: EdgeInsets.only(top: 10),
          child: GenericButton(
            text: stopwatch.isRunning ? 'Stop' : 'Start',
            isPressed: stopwatch.isRunning,
            size: const Size(175, 45),
            onPressed: () {
              if (stopwatch.isRunning) {
                stopTracker(stopwatch);
                loadTimes(tracker.value);
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

ValueNotifier<List<Topic>> topics = ValueNotifier(List.empty());
bool showDropdown = false;

Future<void> loadTopics() async {
  topics.value = await getAllTopics();
}

class TopicDropdown extends StatefulWidget {
  const TopicDropdown({super.key, required this.height});
  final double height;

  @override
  State<TopicDropdown> createState() => _TopicDropdownState();
}

class _TopicDropdownState extends State<TopicDropdown> {
  @override
  void initState() {
    super.initState();
    loadTopics();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<Topic>>(
      valueListenable: topics,
      builder: (context, value, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 24, color: secondaryColor),
                  GestureDetector(
                    onTap: () {
                      newTopicPopup(context);
                    },

                    child: Text('Create Topic', style: bodySmallGrey),
                  ),
                ],
              ),
              ...topics.value.map((topic) {
                return GestureDetector(
                  onTap: () {
                    tracker.value.topicName = topic.name;
                    loadTimes(tracker.value);
                    showDropdown = false;
                  },
                  child: topic.name != tracker.value.topicName
                      ? Text(
                          '${topic.name}: ${Duration(seconds: topic.time).toHoursString()}',
                          style: bodySmallGrey,
                        )
                      : SizedBox.shrink(),
                );
              }),
            ],
          ),
        );
      },
    );
  }
}

void newTopicPopup(BuildContext context) {
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: backgroundColor,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: secondaryColor,
                size: 32,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
        content: Form(
          key: formKey,
          child: TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Topic Name',
              border: OutlineInputBorder(),
            ),
            style: bodyMediumGrey,
          ),
        ),
        actions: [
          GenericButton(
            size: Size(100, 20),
            text: 'Create',
            textStyle: bodyMin,
            onPressed: () {
              createTopic(controller.text);
              loadTopics();
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
