import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../handler/topic.dart';
import '../../models/topic.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import '../widgets/streak.dart';
import '../widgets/time.dart';

Future<void> loadTimes(TrackerValues tracker) async {
  final (secondsTopic, streak) = await getTimeTopic(tracker.topicName);
  final secondsToday = await getTimeToday(topic: tracker.topicName);

  if (secondsTopic != null) {
    tracker.topicTime = secondsTopic;
  }
  if (secondsToday != null) {
    tracker.todayTime = secondsToday;
  }
}

class TrackerValues {
  TrackerValues({
    required this.topicName,
    required this.topicTime,
    required this.todayTime,
    required this.streak,
    required this.countdownTime,
  });
  String topicName;
  int topicTime;
  int todayTime;
  int streak;
  Duration countdownTime;
}

ValueNotifier<TrackerValues> tracker = ValueNotifier(
  TrackerValues(
    topicName: 'General',
    topicTime: 0,
    todayTime: 0,
    streak: 0,
    countdownTime: Duration(minutes: 25),
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
                    SettingsButton(popup: settingsPopup),
                    Padding(
                      padding: EdgeInsets.only(top: height / 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: 5.0,
                        children: [
                          if (tracker.value.streak != 0)
                            Streak(streak: tracker.value.streak),
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
                            0 => Tracker(height: height, stopwatch: stopwatch),
                            // TODO: Do something after countdown runs out
                            1 => Tracker(
                              height: height,
                              stopwatch: timer,
                              isStopwatch: false,
                            ),
                            _ => const SizedBox.shrink(),
                          };
                        },
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: trackerController,
                      count: 2,
                      effect: WormEffect(
                        dotHeight: 16,
                        dotWidth: 16,
                        type: WormType.thin,
                        dotColor: secondaryColor,
                        activeDotColor: foregroundColor,
                      ),
                    ),

                    // TODO: Reset timer
                    Padding(
                      padding: EdgeInsets.only(top: 20),
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
    this.isStopwatch = true,
  });

  final double height;
  final Stopwatch stopwatch;
  final bool isStopwatch;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerValues>(
      valueListenable: tracker,
      builder: (context, value, child) {
        return Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height / 12),
              child: Text(
                (isStopwatch
                        ? (tracker.value.countdownTime - stopwatch.elapsed)
                        : stopwatch.elapsed)
                    .toStopwatchString(),
                style: bodyMax,
              ),
            ),
          ],
        );
      },
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
            Text('Create Topic', style: bodySmallGrey),
          ],
        ),
        content: TextFormField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Topic Name',
            border: OutlineInputBorder(),
          ),
          style: bodyMediumGrey,
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

void settingsPopup(BuildContext context) {
  final secondsController = TextEditingController();
  final minutesController = TextEditingController();
  final hoursController = TextEditingController();

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
            Text('Set Timer', style: bodySmallGrey),
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: SettingsForm(label: 'Hours', controller: hoursController),
            ),
            Expanded(
              child: SettingsForm(
                label: 'Minutes',
                controller: minutesController,
              ),
            ),
            Expanded(
              child: SettingsForm(
                label: 'Seconds',
                controller: secondsController,
              ),
            ),
          ],
        ),
        actions: [
          GenericButton(
            size: Size(100, 20),
            text: 'Save',
            textStyle: bodySmall,
            onPressed: () {
              tracker.value.countdownTime = Duration(
                hours: int.tryParse(hoursController.text) ?? 0,
                minutes: int.tryParse(minutesController.text) ?? 0,
                seconds: int.tryParse(secondsController.text) ?? 0,
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({
    super.key,
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
      style: bodyMediumGrey,
    );
  }
}
