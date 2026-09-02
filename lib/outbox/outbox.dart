import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../handler/topic.dart';

Future<Database> openLocalDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = p.join(directory.path, 'local.db');

  return sqlite3.open(dbPath);
}

Future<void> initializeLocalDB() async {
  final db = await openLocalDatabase();

  db.execute('''
  CREATE TABLE IF NOT EXISTS topic_events (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL,
    time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INTEGER NOT NULL DEFAULT FALSE,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS topics (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL UNIQUE,
    total_time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INTEGER NOT NULL DEFAULT FALSE
  );
  INSERT OR IGNORE INTO topics (topic_name) VALUES ('General');

  CREATE TABLE IF NOT EXISTS user_stats (
    id INTEGER NOT NULL PRIMARY KEY,
    today_time_tracked_seconds INT NOT NULL DEFAULT 0,
    streak INTEGER NOT NULL DEFAULT 0
  );
  INSERT OR IGNORE INTO user_stats (id) VALUES (1);
  ''');
}

Future<void> syncEvents() async {
  Timer.periodic(const Duration(minutes: 1), (_) async {
    final db = await openLocalDatabase();

    await _syncTopicEvents(db);
    await _syncTopics(db);

    db.close();
  });
}

Future<void> _syncTopics(Database db) async {
  final ResultSet resultSet = db.select(
    'SELECT * FROM topics WHERE synced = FALSE;',
  );
  for (final Row row in resultSet) {
    final status = await createTopic('${row['topic_name']}');

    if (status == HttpStatus.ok) {
      final stmt = db.prepare('UPDATE topics SET synced = TRUE WHERE id = ?');
      stmt.execute(row['id']);
    } else {
      // TODO: Delete all together on certain statuses
    }
  }
}

Future<void> _syncTopicEvents(Database db) async {
  final ResultSet resultSet = db.select(
    'SELECT * FROM topic_events WHERE synced = FALSE;',
  );
  for (final Row row in resultSet) {
    final status = await trackTopic(
      '${row['topic_name']}',
      row['time_tracked_seconds'] ?? 0,
      row['created_at'] as DateTime,
    );

    if (status == HttpStatus.ok) {
      final stmt = db.prepare(
        'UPDATE topic_events SET synced = TRUE WHERE id = ?',
      );
      stmt.execute(row['id']);
    } else {
      // TODO: Delete all together on certain statuses
    }
  }
}
