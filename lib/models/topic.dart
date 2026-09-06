class Topic {
  factory Topic.fromJson(Map<String, dynamic> json) {
    return Topic(
      name: json['name'] as String,
      time: json['total_time_tracked_seconds'] as int,
    );
  }
  const Topic({required this.name, required this.time});
  final String name;
  final int time;
}

class TopicEvent {
  TopicEvent({
    required this.topic,
    required this.timeSeconds,
    required this.date,
  });

  factory TopicEvent.fromJson(Map<String, dynamic> json) {
    return TopicEvent(
      topic: json['topic'] as String,
      timeSeconds: json['time_seconds'] as int,
      date: DateTime.parse(json['date'] as String),
    );
  }

  static List<TopicEvent> fromJsonList(Map<String, dynamic> json) {
    final topics = List<String>.from(json['topics'] ?? []);
    final timesTracked = List<int>.from(json['times_tracked'] ?? []);
    final dates = (json['dates'] as List<dynamic>? ?? [])
        .map((date) => DateTime.parse(date as String))
        .toList();

    return List.generate(
      topics.length,
      (index) => TopicEvent(
        topic: topics[index],
        timeSeconds: timesTracked[index],
        date: dates[index],
      ),
    );
  }

  final String topic;
  final int timeSeconds;
  final DateTime date;

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'time_seconds': timeSeconds,
      'date': date.toUtc().toIso8601String(),
    };
  }
}
