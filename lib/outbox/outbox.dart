import 'dart:async';

import 'package:sqlite3/sqlite3.dart';

import 'tracker.dart';

Future<void> initializeLocalDB() async {
  final db = sqlite3.open('local.db');

  db.execute('''
  CREATE TABLE IF NOT EXISTS topic_events (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL,
    time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INT NOT NULL DEFAULT FALSE,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );

  CREATE TABLE IF NOT EXISTS topics (
    id INTEGER NOT NULL PRIMARY KEY,
    topic_name TEXT NOT NULL UNIQUE,
    total_time_tracked_seconds INTEGER NOT NULL DEFAULT 0,
    synced INT NOT NULL DEFAULT FALSE,
    created_at TEXT NOT NULL DEFAULT (datetime('now'))
  );
  INSERT OR IGNORE INTO topics (topic_name) VALUES ('General');
  ''');
}

Future<void> syncEvents() async {
  Timer.periodic(const Duration(minutes: 1), (_) async {
    final db = sqlite3.open('local.db');

    syncTopicEvents(db);

    db.close();
  });
}
