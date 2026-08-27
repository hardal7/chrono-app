import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../handler/topic.dart';
import '../../l10n/app_localizations.dart';
import '../../models/topic.dart';
import '../../services/chrono.dart';
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
    required this.count,
  });

  String topicName;
  int topicTime;
  int todayTime;
  int streak;
  Duration countdownTime;
  int count;
}

ValueNotifier<TrackerValues> trackerNotifier = ValueNotifier(
  TrackerValues(
    topicName: 'General',
    topicTime: 0,
    todayTime: 0,
    streak: 0,
    countdownTime: Duration(minutes: 25),
    count: 1,
  ),
);

class TrackerPage extends StatefulWidget {
  const TrackerPage({super.key});

  @override
  State<TrackerPage> createState() => _TrackerPageState();
}

class _TrackerPageState extends State<TrackerPage> {
  final chrono = ChronoService.instance;
  final trackerController = PageController();
  late Stopwatch currentTracker;

  late Timer uiTimer;
  late Timer topicTimer;

  Future<void> newCount(Stopwatch tracker) async {
    stopTracker(tracker);
    loadTimes(trackerNotifier.value);
    tracker.reset();
    trackerNotifier.value.count++;
  }

  @override
  void initState() {
    super.initState();

    currentTracker = chrono.stopwatch;

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        if (chrono.timer.elapsed >= trackerNotifier.value.countdownTime) {
          newCount(chrono.timer);
        }
        setState(() {});
      }
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadTimes(trackerNotifier.value);
    });

    loadTimes(trackerNotifier.value);
  }

  @override
  void dispose() {
    uiTimer.cancel();
    topicTimer.cancel();
    trackerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, constraints) {
        final height = constraints.maxHeight;
        final width = constraints.maxWidth;

        return ValueListenableBuilder<TrackerValues>(
          valueListenable: trackerNotifier,
          builder: (context, tracker, child) {
            return Material(
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
                          if (tracker.streak != 0)
                            Streak(streak: tracker.streak),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                showDropdown = !showDropdown;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  tracker.topicName,
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
                                    color: colors.onSurface,
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
                                  '${Duration(seconds: tracker.topicTime).toStopwatchString()} ${l10n.overall}',
                                  style: bodyMedium.copyWith(
                                    color: colors.secondary,
                                  ),
                                ),
                                TodayTime(todayTime: tracker.todayTime),
                              ],
                            ),
                    ),
                    SizedBox(
                      height: height / 3.5,
                      child: PageView.builder(
                        onPageChanged: (page) {
                          setState(() {
                            currentTracker = (page == 0
                                ? chrono.timer
                                : chrono.stopwatch);
                          });
                        },
                        itemCount: 2,
                        controller: trackerController,
                        itemBuilder: (_, index) {
                          return switch (index) {
                            0 => Tracker(
                              height: height,
                              elapsed: chrono.timer.elapsed,
                              isStopwatch: false,
                            ),
                            // TODO: Do something after countdown runs out
                            1 => Tracker(
                              height: height,
                              elapsed: chrono.stopwatch.elapsed,
                            ),
                            _ => const SizedBox.shrink(),
                          };
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: height / 16),
                      child: Text(
                        'Count ${tracker.count}',
                        style: bodyMedium.copyWith(color: colors.secondary),
                      ),
                    ),
                    SmoothPageIndicator(
                      controller: trackerController,
                      count: 2,
                      effect: WormEffect(
                        dotHeight: 16,
                        dotWidth: 16,
                        type: WormType.thin,
                        dotColor: colors.secondary,
                        activeDotColor:
                            themeNotifier.value.brightness == Brightness.dark
                            ? colors.onSurface
                            : colors.primary,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: SizedBox(
                        width: width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GenericButton(
                              text: currentTracker.isRunning
                                  ? l10n.pause
                                  : l10n.start,
                              isPressed: currentTracker.isRunning,
                              size: const Size(175, 45),
                              onPressed: () {
                                if (currentTracker.isRunning) {
                                  stopTracker(currentTracker);
                                  loadTimes(tracker);
                                } else {
                                  startTracker(currentTracker);
                                }
                              },
                            ),
                            if (currentTracker.isRunning)
                              Positioned(
                                right: width / 2.65,
                                child: GestureDetector(
                                  onTap: () {
                                    newCount(currentTracker);
                                  },
                                  child: Icon(
                                    Icons.skip_next,
                                    color: colors.onSurface,
                                    size: 40,
                                  ),
                                ),
                              ),
                          ],
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
    required this.elapsed,
    this.isStopwatch = true,
  });

  final double height;
  final Duration elapsed;
  final bool isStopwatch;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerValues>(
      valueListenable: trackerNotifier,
      builder: (context, tracker, child) {
        return Center(
          child: Padding(
            padding: EdgeInsets.only(top: height / 15),
            child: Text(
              (isStopwatch ? elapsed : (tracker.countdownTime - elapsed))
                  .toStopwatchString(),
              style: bodyMax,
            ),
          ),
        );
      },
    );
  }
}

ValueNotifier<List<Topic>> topicsNotifier = ValueNotifier(List.empty());
bool showDropdown = false;

Future<void> loadTopics() async {
  topicsNotifier.value = await getAllTopics();
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
    final colors = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<List<Topic>>(
      valueListenable: topicsNotifier,
      builder: (context, topics, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add, size: 24, color: colors.secondary),
                  GestureDetector(
                    onTap: () {
                      newTopicPopup(context);
                    },
                    child: Text(
                      l10n.createTopic,
                      style: bodySmall.copyWith(color: colors.secondary),
                    ),
                  ),
                ],
              ),
              ...topics.map((topic) {
                return GestureDetector(
                  onTap: () {
                    trackerNotifier.value.topicName = topic.name;
                    loadTimes(trackerNotifier.value);
                    showDropdown = false;
                  },
                  child: topic.name != trackerNotifier.value.topicName
                      ? Text(
                          '${topic.name}: ${Duration(seconds: topic.time).toHoursString()}',
                          style: bodySmall.copyWith(color: colors.secondary),
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
  final colors = Theme.of(context).colorScheme;
  final l10n = AppLocalizations.of(context)!;
  final controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: colors.secondary, size: 32),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              l10n.createTopic,
              style: bodySmall.copyWith(color: colors.secondary),
            ),
          ],
        ),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            labelText: l10n.topicName,
            labelStyle: bodySmall.copyWith(color: colors.secondary),
            border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: colors.secondary),
            ),
          ),
          style: bodyMedium.copyWith(color: colors.secondary),
        ),
        actions: [
          GenericButton(
            size: Size(100, 20),
            text: l10n.create,
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
      final colors = Theme.of(context).colorScheme;
      final l10n = AppLocalizations.of(context)!;

      return AlertDialog(
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.chevron_left, color: colors.secondary, size: 32),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Text(
              l10n.setTimer,
              style: bodySmall.copyWith(color: colors.secondary),
            ),
          ],
        ),
        content: Row(
          children: [
            Expanded(
              child: SettingsForm(
                label: l10n.hours,
                controller: hoursController,
                isNumber: true,
              ),
            ),
            Expanded(
              child: SettingsForm(
                label: l10n.minutes,
                controller: minutesController,
                isNumber: true,
              ),
            ),
            Expanded(
              child: SettingsForm(
                label: l10n.seconds,
                controller: secondsController,
                isNumber: true,
              ),
            ),
          ],
        ),
        actions: [
          GenericButton(
            size: Size(100, 20),
            text: l10n.save,
            textStyle: bodySmall,
            onPressed: () {
              trackerNotifier.value.countdownTime = Duration(
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
