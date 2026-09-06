import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../handler/topic.dart';
import '../handler/user.dart';
import '../main.dart';
import '../models/topic.dart';
import '../models/user.dart';
import '../services/tracker.dart';
import 'sqlite.dart';

Future<void> loadTimes(ValueNotifier<TrackerValues> tracker) async {
  final db = await openLocalDatabase();

  int? secondsTopic, secondsToday, streak;
  secondsTopic = await getTimeTopic(tracker.value.topicName);
  secondsToday = await getTimeToday(topic: tracker.value.topicName);

  final UserProfile? user = await getProfile(username);
  streak = user?.streak ?? 0;

  secondsTopic ??= await _getTimeTopicLocal(tracker.value.topicName);
  if (secondsToday == null) {
    (secondsToday, streak) = await _getUserStatsLocal(db);
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

  if (resultSet.isNotEmpty) {
    final row = resultSet[0];
    return row['total_time_tracked_seconds'] as int;
  }

  return 0;
}

// TODO: Local streak tracking
Future<(int, int)> _getUserStatsLocal(Database db) async {
  final resultSet = await db.rawQuery('SELECT * FROM user_stats');

  if (resultSet.isNotEmpty) {
    final row = resultSet[0];
    return (row['today_time_tracked_seconds'] as int, row['streak'] as int);
  }

  return (0, 0);
}

Future<void> saveTimes(String topic, int timeTrackedSeconds) async {
  final db = await openLocalDatabase();

  final DateTime createdAt = DateTime.now().toUtc();
  var status = await trackTopic(
    TopicEvent(topic: topic, timeSeconds: timeTrackedSeconds, date: createdAt),
  );
  if (status == HttpStatus.ok) {
    await _saveLocally(db, topic, timeTrackedSeconds, createdAt);
  } else {
    await _saveLocally(db, topic, timeTrackedSeconds, createdAt, synced: false);
  }
}

Future<void> _saveLocally(
  Database db,
  String topic,
  int timeTrackedSeconds,
  DateTime createdAt, {
  bool synced = true,
}) async {
  if (timeTrackedSeconds < 0) {
    return;
  }

  await db.execute(
    'INSERT INTO topic_events (topic_name, time_tracked_seconds, created_at, synced) VALUES (?, ?, ?, ?)',
    [topic, timeTrackedSeconds, createdAt.toIso8601String(), synced ? 1 : 0],
  );

  await db.execute(
    'UPDATE topics SET total_time_tracked_seconds = total_time_tracked_seconds + ? WHERE topic_name = ?',
    [timeTrackedSeconds, topic],
  );

  await db.execute(
    'UPDATE user_stats SET today_time_tracked_seconds = today_time_tracked_seconds + ?',
    [timeTrackedSeconds],
  );
}
