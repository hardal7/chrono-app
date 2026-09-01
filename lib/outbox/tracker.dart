import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqlite3/sqlite3.dart';

import '../handler/topic.dart';
import '../services/dio.dart';
import '../services/tracker.dart';

Future<void> loadTimes(ValueNotifier<TrackerValues> tracker) async {
  int? secondsTopic, secondsToday, streak; // TODO: streak
  (secondsTopic, streak) = await getTimeTopic(tracker.value.topicName);
  secondsToday = await getTimeToday(topic: tracker.value.topicName);

  secondsTopic ??= await _getTimeTopicLocal(tracker.value.topicName);
  secondsToday ??= 0;

  tracker.value.todayTime = secondsToday;
  tracker.value.topicTime = secondsTopic;
}

Future<void> saveTimes(String topic, int timeTrackedSeconds) async {
  debugPrint('Trying to track time');

  final String createdAt = DateTime.now().toUtc().toIso8601String();
  await _saveLocally(topic, timeTrackedSeconds, createdAt);
  await _post(topic, timeTrackedSeconds, createdAt);
}

Future<void> syncTopicEvents(Database db) async {
  final ResultSet resultSet = db.select(
    'SELECT * FROM topic_events WHERE synced = FALSE;',
  );
  for (final Row row in resultSet) {
    final status = await _post(
      '${row['topic_name']}',
      row['time_tracked_seconds'] ?? 0,
      '${row['created_at']}',
    );

    if (status == HttpStatus.ok) {
      final stmt = db.prepare(
        'UPDATE topic_events SET synced = TRUE WHERE id = ?',
      );
      stmt.execute(row['id']);
    } else {
      // debugPrint('Failed to track time');
    }
  }
}

Future<int> _getTimeTopicLocal(String topicName) async {
  final db = sqlite3.open('local.db');

  final ResultSet resultSet = db.select(
    'SELECT * FROM topics WHERE topic_name = ?;',
    [topicName],
  );

  db.close();
  if (resultSet.isNotEmpty) {
    final Row row = resultSet[0];
    return row['total_time_tracked_seconds'];
  }

  return 0;
}

Future<int> _post(String topic, int timeTrackedSeconds, String date) async {
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic-event/track',
      data: {'topic': topic, 'time_seconds': timeTrackedSeconds, 'date': date},
    );
    return response.statusCode ?? 0;
  } catch (e) {
    return 0;
  }
}

Future<void> _saveLocally(
  String topic,
  int timeTrackedSeconds,
  String createdAt,
) async {
  final db = sqlite3.open('local.db');

  db.execute(
    'INSERT INTO topic_events (topic_name, time_tracked_seconds, created_at) VALUES (?, ?, ?)',
    [topic, timeTrackedSeconds, createdAt],
  );

  db.execute(
    'UPDATE topics SET total_time_tracked_seconds = total_time_tracked_seconds + ? WHERE topic_name = ?',
    [timeTrackedSeconds, topic],
  );

  db.close();
}
