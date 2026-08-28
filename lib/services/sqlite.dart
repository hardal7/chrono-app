import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sqlite3/sqlite3.dart';

import '../presentation/pages/tracker.dart';
import 'dio.dart';

void saveTopicEvent(String topic, int timeTrackedSeconds) async {
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic-event/track',
      data: {
        'topic': topic,
        'time_seconds': timeTrackedSeconds,
        'date': DateTime.now().toUtc().toIso8601String(),
      },
    );

    debugPrint(response.statusCode.toString());
  } on DioException catch (e) {
    debugPrint('Trying to track time');
    debugPrint(e.error.toString());

    await _saveLocally(topic, timeTrackedSeconds);
    trackerNotifier.value.topicTime += timeTrackedSeconds;
    trackerNotifier.value.todayTime += timeTrackedSeconds;
  }
}

Future<void> _saveLocally(String topic, int timeTrackedSeconds) async {
  final db = sqlite3.open('local.db');

  db.execute('''
  CREATE TABLE IF NOT EXISTS topic_events (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL,
    time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
  );
  ''');

  final stmt = db.prepare(
    'INSERT INTO topic_events (topic_name, time_tracked_seconds) VALUES (?, ?)',
  );
  stmt.execute([topic, timeTrackedSeconds]);
  stmt.close();

  db.close();
}

Future<void> syncEvents() async {
  Timer.periodic(const Duration(minutes: 1), (_) async {
    final db = sqlite3.open('local.db');

    final ResultSet resultSet = db.select('SELECT * FROM topic_events;');
    for (final Row row in resultSet) {
      try {
        await dio.post(
          '${dotenv.get('API_URL')}/topic-event/track',
          data: {
            'topic': '${row['topic_name']}',
            'time_seconds': row['time_tracked_seconds'] ?? 0,
            'date': '${row['created_at']}',
          },
        );

        final stmt = db.prepare('DELETE FROM topic_events WHERE id = ?');
        stmt.execute(row['id']);
        stmt.close();
      } on DioException catch (e) {
        debugPrint('Failed to track time');
        debugPrint(e.error.toString());
        db.close();
        return;
      }
    }

    db.close();
  });
}
