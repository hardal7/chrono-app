import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';

import '../handler/topic.dart';
import '../models/topic.dart';
import 'sqlite.dart';

Future<void> newTopic(String topic) async {
  final db = await openLocalDatabase();

  var status = await createTopic(topic);
  if (status == HttpStatus.ok) {
    await _saveLocally(db, topic);
  } else {
    await _saveLocally(db, topic, synced: false);
  }
}

Future<void> _saveLocally(
  Database db,
  String topic, {
  bool synced = true,
}) async {
  debugPrint('Synced? ${synced ? 1 : 0}');
  await db.execute('INSERT INTO topics (topic_name, synced) VALUES (?, ?)', [
    topic,
    synced ? 1 : 0,
  ]);
}

Future<void> loadTopics(ValueNotifier<List<Topic>> topicList) async {
  final db = await openLocalDatabase();

  List<Topic> topics;
  topics = await getAllTopics();

  if (topics.isEmpty) {
    topics = await _getTopicsLocal(db);
  }

  topicList.value = topics;
}

Future<List<Topic>> _getTopicsLocal(Database db) async {
  final resultSet = await db.rawQuery('SELECT * FROM topics');

  return resultSet.map((row) {
    return Topic(
      name: row['topic_name'] as String,
      time: row['total_time_tracked_seconds'] as int,
    );
  }).toList();
}
