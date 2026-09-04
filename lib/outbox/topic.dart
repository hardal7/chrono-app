import 'dart:io';

import 'package:flutter/foundation.dart';

import '../handler/topic.dart';
import '../models/topic.dart';
import 'sqlite.dart';

Future<void> newTopic(String topic) async {
  var status = await createTopic(topic);
  if (status == HttpStatus.ok) {
    await _saveLocally(topic);
  } else {
    await _saveLocally(topic, synced: false);
  }
}

Future<void> _saveLocally(String topic, {bool synced = true}) async {
  final db = await openLocalDatabase();

  debugPrint('Synced? ${synced ? 1 : 0}');
  await db.execute('INSERT INTO topics (topic_name, synced) VALUES (?, ?)', [
    topic,
    synced ? 1 : 0,
  ]);

  await db.close();
}

Future<void> loadTopics(ValueNotifier<List<Topic>> topicList) async {
  List<Topic> topics;
  topics = await getAllTopics();

  if (topics.isEmpty) {
    topics = await _getTopicsLocal();
  }

  topicList.value = topics;
}

Future<List<Topic>> _getTopicsLocal() async {
  final db = await openLocalDatabase();
  final resultSet = await db.rawQuery('SELECT * FROM topics');

  await db.close();

  return resultSet.map((row) {
    return Topic(
      name: row['topic_name'] as String,
      time: row['total_time_tracked_seconds'] as int,
    );
  }).toList();
}
