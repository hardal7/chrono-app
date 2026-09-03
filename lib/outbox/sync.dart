import 'dart:async';
import 'dart:io';

import 'package:sqflite/sqflite.dart';

import '../handler/topic.dart';
import 'sqlite.dart';

Future<void> syncEvents() async {
  Timer.periodic(const Duration(minutes: 1), (_) async {
    final db = await openLocalDatabase();

    await _syncTopicEvents(db);
    await _syncTopics(db);

    db.close();
  });
}

Future<void> _syncTopics(Database db) async {
  final rows = await db.rawQuery('SELECT * FROM topics WHERE synced = FALSE');

  for (final row in rows) {
    final status = await createTopic(row['topic_name'] as String);

    if (status == HttpStatus.ok) {
      await db.rawUpdate('UPDATE topics SET synced = TRUE WHERE id = ?', [
        row['id'],
      ]);
    }
  }
}

Future<void> _syncTopicEvents(Database db) async {
  final rows = await db.rawQuery(
    'SELECT * FROM topic_events WHERE synced = FALSE',
  );

  for (final row in rows) {
    final status = await trackTopic(
      row['topic_name'] as String,
      (row['time_tracked_seconds'] as num?)?.toInt() ?? 0,
      DateTime.parse(row['created_at'] as String),
    );

    if (status == HttpStatus.ok) {
      await db.rawUpdate('UPDATE topic_events SET synced = TRUE WHERE id = ?', [
        row['id'],
      ]);
    }
  }
}
