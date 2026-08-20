class UserProfile {
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      username: json['username'] as String,
      avatarPath: json['avatar_path'] as String,
      country: json['country'] as String,
      totalTime: json['total_time_seconds'] as int,
      todayTime: json['today_time_seconds'] as int,
      bestTopic: json['best_topic'] as String,
      friendStatus: json['friend_status'] as String,
    );
  }

  const UserProfile({
    required this.username,
    required this.avatarPath,
    required this.country,
    required this.totalTime,
    required this.todayTime,
    required this.bestTopic,
    required this.friendStatus,
  });

  final String username;
  final String avatarPath;
  final String country;
  final int totalTime;
  final int todayTime;
  final String bestTopic;
  final String friendStatus;
}
