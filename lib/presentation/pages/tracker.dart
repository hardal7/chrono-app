import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../l10n/app_localizations.dart';
import '../../models/topic.dart';
import '../../outbox/topic.dart';
import '../../outbox/tracker.dart';
import '../../services/tracker.dart';
import '../duration.dart';
import '../style.dart';
import '../widgets/button.dart';
import '../widgets/settings.dart';
import '../widgets/streak.dart';
import '../widgets/time.dart';

final ValueNotifier<TrackerValues> trackerNotifier = ValueNotifier(
  TrackerValues(
    topicName: 'General',
    topicTime: 0,
    todayTime: 0,
    streak: 0,
    currentTracker: Stopwatch(),
    countdownTime: Duration(minutes: 25),
    breakTime: Duration(minutes: 5),
    isBreak: false,
    count: 1,
    breakCount: 1,
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

  late Timer uiTimer;
  late Timer topicTimer;

  Future<void> fetchLatestTopic() async {
    final prefs = await SharedPreferences.getInstance();
    trackerNotifier.value.topicName = prefs.getString('topic') ?? 'General';

    loadTimes(trackerNotifier);
  }

  @override
  void initState() {
    super.initState();

    trackerNotifier.value.currentTracker = chrono.timer;

    fetchLatestTopic();

    uiTimer = Timer.periodic(const Duration(milliseconds: 500), (_) async {
      if (mounted) {
        if ((chrono.timer.elapsed >= trackerNotifier.value.countdownTime) ||
            (chrono.breakTimer.elapsed >= trackerNotifier.value.breakTime)) {
          await toggleTimer(trackerNotifier, chrono);
        }
        setState(() {});
      }
    });

    topicTimer = Timer.periodic(const Duration(minutes: 1), (_) async {
      await loadTimes(trackerNotifier);
    });
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return ValueListenableBuilder<TrackerValues>(
      valueListenable: trackerNotifier,
      builder: (context, tracker, child) {
        return Material(
          child: Padding(
            padding: pageInset,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 10,
              children: [
                SettingsButton(popup: settingsPopup),
                Spacer(flex: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 5.0,
                  children: [
                    if (tracker.streak != 0) Streak(streak: tracker.streak),
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
                              fontWeight: FontWeight(showDropdown ? 900 : 100),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                showDropdown
                    ? TopicDropdown()
                    : Column(
                        children: [
                          Text(
                            '${Duration(seconds: tracker.topicTime).toStopwatchString()} ${l10n.overall}',
                            style: bodyMedium.copyWith(color: colors.secondary),
                          ),
                          TodayTime(todayTime: tracker.todayTime),
                        ],
                      ),
                Expanded(
                  flex: 20,
                  child: PageView.builder(
                    onPageChanged: (page) {
                      setState(() {
                        tracker.currentTracker = (page == 0
                            ? chrono.timer
                            : chrono.stopwatch);
                      });
                    },
                    itemCount: 2,
                    controller: trackerController,
                    itemBuilder: (_, index) {
                      return switch (index) {
                        0 => Tracker(
                          elapsed: tracker.currentTracker == chrono.timer
                              ? chrono.timer.elapsed
                              : chrono.breakTimer.elapsed,
                          isStopwatch: false,
                          countdown: tracker.currentTracker == chrono.timer
                              ? tracker.countdownTime
                              : tracker.breakTime,
                        ),
                        1 => Tracker(elapsed: chrono.stopwatch.elapsed),
                        _ => const SizedBox.shrink(),
                      };
                    },
                  ),
                ),
                Center(
                  child: Text(
                    tracker.currentTracker == chrono.stopwatch
                        ? ''
                        : tracker.currentTracker == chrono.timer
                        ? 'Count ${tracker.count}'
                        : 'Break ${tracker.breakCount}',
                    style: bodyMedium.copyWith(color: colors.secondary),
                  ),
                ),
                Spacer(flex: 4),
                Center(
                  child: SmoothPageIndicator(
                    controller: trackerController,
                    count: 2,
                    effect: WormEffect(
                      dotHeight: 16,
                      dotWidth: 16,
                      type: WormType.thin,
                      dotColor: colors.secondary,
                      activeDotColor: theme.brightness == Brightness.dark
                          ? colors.onSurface
                          : colors.primary,
                    ),
                  ),
                ),
                Spacer(flex: 1),
                Row(
                  children: [
                    Expanded(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.45,
                            child: GenericButton(
                              text: tracker.currentTracker.isRunning
                                  ? l10n.pause
                                  : l10n.start,
                              isPressed: tracker.currentTracker.isRunning,
                              playSound: true,
                              onPressed: () async {
                                if (tracker.currentTracker.isRunning) {
                                  await stopTracker(trackerNotifier);
                                } else {
                                  startTracker(tracker.currentTracker);
                                }
                              },
                            ),
                          ),
                          if (tracker.currentTracker.isRunning &&
                              tracker.currentTracker != chrono.stopwatch)
                            Positioned(
                              right: 60,
                              child: GestureDetector(
                                onTap: () async {
                                  await toggleTimer(trackerNotifier, chrono);
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
                  ],
                ),
                Spacer(flex: 4),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Tracker extends StatelessWidget {
  const Tracker({
    super.key,
    required this.elapsed,
    this.isStopwatch = true,
    this.countdown = const Duration(minutes: 5),
  });

  final Duration countdown;
  final Duration elapsed;
  final bool isStopwatch;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TrackerValues>(
      valueListenable: trackerNotifier,
      builder: (context, tracker, child) {
        return Center(
          child: Text(
            (isStopwatch ? elapsed : (countdown - elapsed)).toStopwatchString(),
            style: bodyMax,
          ),
        );
      },
    );
  }
}

ValueNotifier<List<Topic>> topicsNotifier = ValueNotifier(List.empty());
bool showDropdown = false;

class TopicDropdown extends StatefulWidget {
  const TopicDropdown({super.key});

  @override
  State<TopicDropdown> createState() => _TopicDropdownState();
}

class _TopicDropdownState extends State<TopicDropdown> {
  @override
  void initState() {
    super.initState();
    loadTopics(topicsNotifier);
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
                  onTap: () async {
                    trackerNotifier.value.topicName = topic.name;
                    loadTimes(trackerNotifier);

                    Stopwatch tracker = trackerNotifier.value.currentTracker;
                    await stopTracker(trackerNotifier);
                    tracker.reset();

                    final prefs = await SharedPreferences.getInstance();
                    prefs.setString('topic', topic.name);

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
            text: l10n.create,
            textStyle: bodySmall,
            onPressed: () {
              newTopic(controller.text);
              loadTopics(topicsNotifier);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

void settingsPopup(BuildContext context) {
  final countdownController = TextEditingController();
  final breakController = TextEditingController();

  final focusNode = FocusNode();

  showDialog(
    context: context,
    builder: (context) {
      final colors = Theme.of(context).colorScheme;
      final l10n = AppLocalizations.of(context)!;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          focusNode.requestFocus();
        }
      });

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
                label: l10n.minutes,
                controller: countdownController,
                focusNode: focusNode,
                isNumber: true,
              ),
            ),
            Expanded(
              child: SettingsForm(
                label: 'Break Time',
                controller: breakController,
                isNumber: true,
              ),
            ),
          ],
        ),
        actions: [
          GenericButton(
            text: l10n.save,
            textStyle: bodySmall,
            onPressed: () {
              trackerNotifier.value.countdownTime = Duration(
                minutes: int.tryParse(countdownController.text) ?? 0,
              );
              trackerNotifier.value.breakTime = Duration(
                minutes: int.tryParse(breakController.text) ?? 0,
              );
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
