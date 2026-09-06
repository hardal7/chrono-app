import 'package:sqflite/sqflite.dart';

import '../handler/topic.dart';
import '../handler/user.dart';
import '../models/topic.dart';
import '../models/user.dart';
import '../presentation/pages/users.dart';
import 'sqlite.dart';

Future<void> fetchAllData() async {
  final db = await openLocalDatabase();
  await _deleteLocal(db);

  var profile = await getProfile(username);
  if (profile == null) {
    return;
  }
  var topics = await getAllTopics();
  var topicEvents = await getTopicEvents();

  await _saveLocally(db, profile, topics, topicEvents);
}

Future<void> _deleteLocal(Database db) async {
  await db.execute('DELETE * FROM topic_event');
  await db.execute('DELETE * FROM topics');
  await db.execute('DELETE * FROM user_stats');
}

Future<void> _saveLocally(
  Database db,
  UserProfile profile,
  List<Topic> topics,
  List<TopicEvent> topicEvents,
) async {
  await db.execute(
    'INSERT INTO user_stats (today_time_tracked_seconds, streak) VALUES (?, ?)',
    [profile.todayTime, profile.streak],
  );

  for (final topic in topics) {
    await db.execute(
      'INSERT INTO topics (topic_name, total_time_tracked_seconds synced) VALUES (?, ?, ?)',
      [topic.name, topic.time, 1],
    );
  }

  for (final event in topicEvents) {
    await db.execute(
      'INSERT INTO topic_events (topic_name, time_tracked_seconds, synced, created_at) VALUES (?, ?, ?, ?)',
      [event.topic, event.timeSeconds, 1, event.date.toUtc().toIso8601String()],
    );
  }
}
