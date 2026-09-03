import 'package:flutter/foundation.dart';

import '../handler/topic.dart';
import '../handler/user.dart';
import '../main.dart';
import '../models/user.dart';
import '../services/tracker.dart';
import 'sqlite.dart';

Future<void> loadTimes(ValueNotifier<TrackerValues> tracker) async {
  int? secondsTopic, secondsToday, streak;
  secondsTopic = await getTimeTopic(tracker.value.topicName);
  secondsToday = await getTimeToday(topic: tracker.value.topicName);

  final UserProfile? user = await getProfile(username);
  streak = user?.streak ?? 0;

  secondsTopic ??= await _getTimeTopicLocal(tracker.value.topicName);
  if (secondsToday == null) {
    (secondsToday, streak) = await _getUserStatsLocal();
  }

  tracker.value.todayTime = secondsToday;
  tracker.value.topicTime = secondsTopic;
  tracker.value.streak = streak;
}

Future<int> _getTimeTopicLocal(String topicName) async {
  final db = await openLocalDatabase();
  final resultSet = await db.rawQuery(
    'SELECT * FROM topics WHERE topic_name = ?',
    [topicName],
  );
  await db.close();

  if (resultSet.isNotEmpty) {
    final row = resultSet[0];
    return row['total_time_tracked_seconds'] as int;
  }

  return 0;
}

// TODO: Local streak tracking
Future<(int, int)> _getUserStatsLocal() async {
  final db = await openLocalDatabase();
  final resultSet = await db.rawQuery('SELECT * FROM user_stats');
  await db.close();

  if (resultSet.isNotEmpty) {
    final row = resultSet[0];
    return (row['today_time_tracked_seconds'] as int, row['streak'] as int);
  }

  return (0, 0);
}

Future<void> saveTimes(String topic, int timeTrackedSeconds) async {
  final DateTime createdAt = DateTime.now().toUtc();
  await _saveLocally(topic, timeTrackedSeconds, createdAt);
  await trackTopic(topic, timeTrackedSeconds, createdAt);
}

Future<void> _saveLocally(
  String topic,
  int timeTrackedSeconds,
  DateTime createdAt,
) async {
  final db = await openLocalDatabase();

  if (timeTrackedSeconds < 0) {
    return;
  }

  await db.execute(
    'INSERT INTO topic_events (topic_name, time_tracked_seconds, created_at) VALUES (?, ?, ?)',
    [topic, timeTrackedSeconds, createdAt.toIso8601String()],
  );

  await db.execute(
    'UPDATE topics SET total_time_tracked_seconds = total_time_tracked_seconds + ? WHERE topic_name = ?',
    [timeTrackedSeconds, topic],
  );

  await db.execute(
    'UPDATE user_stats SET today_time_tracked_seconds = today_time_tracked_seconds + ?',
    [timeTrackedSeconds],
  );

  await db.close();
}
