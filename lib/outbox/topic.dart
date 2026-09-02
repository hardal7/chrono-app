import 'package:flutter/foundation.dart';
import 'package:sqlite3/sqlite3.dart';

import '../handler/topic.dart';
import '../models/topic.dart';
import 'outbox.dart';

Future<void> newTopic(String topic) async {
  await _saveLocally(topic);
  await createTopic(topic);
}

Future<void> _saveLocally(String topic) async {
  final db = await openLocalDatabase();

  db.execute('INSERT INTO topics (topic_name) VALUES (?)', [topic]);

  db.close();
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
  final ResultSet resultSet = db.select('SELECT * FROM topics;');
  db.close();

  return resultSet.map((row) {
    return Topic(
      name: row['topic_name'] as String,
      time: row['total_time_tracked_seconds'] as int,
    );
  }).toList();
}
