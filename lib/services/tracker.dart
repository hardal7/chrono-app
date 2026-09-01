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

Future<void> newCount(
  ValueNotifier<TrackerValues> tracker,
  Stopwatch chrono,
) async {
  await stopTracker(tracker);
  chrono.reset();
  tracker.value.count++;
}

class TrackerValues {
  TrackerValues({
    required this.topicName,
    required this.topicTime,
    required this.todayTime,
    required this.streak,
    required this.currentTracker,
    required this.countdownTime,
    required this.count,
  });

  String topicName;
  int topicTime;
  int todayTime;
  int streak;
  Stopwatch currentTracker;
  Duration countdownTime;
  int count;
}

class ChronoService {
  ChronoService._();
  static final ChronoService instance = ChronoService._();

  final Stopwatch timer = Stopwatch();
  final Stopwatch stopwatch = Stopwatch();
}
