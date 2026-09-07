import '../models/topic.dart';
import '../outbox/sqlite.dart';

Future<List<int>> getStats() async {
  final db = await openLocalDatabase();

  final resultSet = await db.rawQuery('''
    SELECT *
    FROM topic_events
    WHERE created_at >= datetime('now', '-7 days');
  ''');

  final events = resultSet.map((row) {
    return TopicEvent(
      topic: row['topic_name'] as String,
      timeSeconds: row['time_tracked_seconds'] as int,
      date: DateTime.parse(row['created_at'] as String),
    );
  }).toList();

  final weeklySeconds = List<int>.filled(7, 0);

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);

  final monday = today.subtract(
    Duration(days: today.weekday - DateTime.monday),
  );

  for (final event in events) {
    final eventDate = DateTime(
      event.date.year,
      event.date.month,
      event.date.day,
    );

    final index = eventDate.difference(monday).inDays;
    weeklySeconds[index] += event.timeSeconds;
  }

  return weeklySeconds;
}
