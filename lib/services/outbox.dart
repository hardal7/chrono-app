import 'dart:async';
import 'dart:io';

import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqlite3/sqlite3.dart';

import '../presentation/pages/tracker.dart';
import 'dio.dart';

void saveTopicEvent(String topic, int timeTrackedSeconds) async {
  debugPrint('Trying to track time');

  final String createdAt = DateTime.now().toUtc().toIso8601String();
  final status = await _postTopicEvent(topic, timeTrackedSeconds, createdAt);

  if (status != HttpStatus.ok) {
    await _saveLocally(topic, timeTrackedSeconds, createdAt);
    trackerNotifier.value.topicTime += timeTrackedSeconds;
    trackerNotifier.value.todayTime += timeTrackedSeconds;
  }
}

Future<void> _saveLocally(
  String topic,
  int timeTrackedSeconds,
  String createdAt,
) async {
  final db = sqlite3.open('local.db');

  db.execute('''
  CREATE TABLE IF NOT EXISTS topic_events (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL,
    time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL
  );
  ''');

  final stmt = db.prepare(
    'INSERT INTO topic_events (topic_name, time_tracked_seconds, created_at) VALUES (?, ?, ?)',
  );
  stmt.execute([topic, timeTrackedSeconds, createdAt]);
  stmt.close();

  db.close();
}

Future<int> _postTopicEvent(
  String topic,
  int timeTrackedSeconds,
  String date,
) async {
  final response = await dio.post(
    '${dotenv.get('API_URL')}/topic-event/track',
    data: {'topic': topic, 'time_seconds': timeTrackedSeconds, 'date': date},
  );
  return response.statusCode ?? 0;
}

Future<void> syncEvents() async {
  Timer.periodic(const Duration(minutes: 1), (_) async {
    final db = sqlite3.open('local.db');

    final ResultSet resultSet = db.select('SELECT * FROM topic_events;');
    for (final Row row in resultSet) {
      final status = await _postTopicEvent(
        '${row['topic_name']}',
        row['time_tracked_seconds'] ?? 0,
        '${row['created_at']}',
      );

      if (status == HttpStatus.ok) {
        final stmt = db.prepare('DELETE FROM topic_events WHERE id = ?');
        stmt.execute(row['id']);
        stmt.close();
      } else {
        debugPrint('Failed to track time');
      }
    }

    db.close();
  });
}
