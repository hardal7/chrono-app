class SessionUser {
  factory SessionUser.fromJson(Map<String, dynamic> json) {
    return SessionUser(
      username: json['username'] as String,
      totalTime: Duration(seconds: json['total_time'] as int),
      todayTime: Duration(seconds: json['today_time'] as int),
      avatarPath: json['avatar_path'] as String,
    );
  }
  const SessionUser({
    required this.username,
    required this.totalTime,
    required this.todayTime,
    required this.avatarPath,
  });
  final String username;
  final Duration totalTime;
  final Duration todayTime;
  final String avatarPath;
}
