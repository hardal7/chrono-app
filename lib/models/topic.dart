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
