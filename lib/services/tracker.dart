import 'package:flutter/foundation.dart';

import '../outbox/tracker.dart';

void startTracker(Stopwatch stopwatch) {
  stopwatch.start();
}

Duration totalTime = Duration.zero;
Future<void> stopTracker(ValueNotifier<TrackerValues> tracker) async {
  Stopwatch stopwatch = tracker.value.currentTracker;
  stopwatch.stop();
  Duration timeTracked = stopwatch.elapsed - totalTime;
  totalTime = stopwatch.elapsed;

  await saveTimes(tracker.value.topicName, timeTracked.inSeconds);
  await loadTimes(tracker);
}

Future<void> toggleTimer(
  ValueNotifier<TrackerValues> tracker,
  ChronoService chrono,
) async {
  await stopTracker(tracker);
  if (tracker.value.currentTracker == chrono.timer) {
    chrono.timer.reset();
    tracker.value.currentTracker = chrono.breakTimer;
    tracker.value.count++;
  } else {
    chrono.breakTimer.reset();
    tracker.value.currentTracker = chrono.timer;
    tracker.value.breakCount++;
  }
}

class TrackerValues {
  TrackerValues({
    required this.topicName,
    required this.topicTime,
    required this.todayTime,
    required this.streak,
    required this.currentTracker,
    required this.countdownTime,
    required this.breakTime,
    required this.isBreak,
    required this.count,
    required this.breakCount,
  });

  String topicName;
  int topicTime;
  int todayTime;
  int streak;

  Stopwatch currentTracker;
  Duration countdownTime;
  Duration breakTime;

  bool isBreak;
  int count;
  int breakCount;
}

class ChronoService {
  ChronoService._();
  static final ChronoService instance = ChronoService._();

  final Stopwatch timer = Stopwatch();
  final Stopwatch stopwatch = Stopwatch();
  final Stopwatch breakTimer = Stopwatch();
}
