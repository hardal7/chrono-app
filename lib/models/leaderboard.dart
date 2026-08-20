class LeaderboardUser {
  factory LeaderboardUser.fromJson(Map<String, dynamic> json) {
    return LeaderboardUser(
      rank: json['rank'] as int,
      username: json['username'] as String,
      totalTime: Duration(seconds: json['total_time'] as int),
      todayTime: Duration(seconds: json['today_time'] as int),
      avatarPath: json['avatar_path'] as String,
    );
  }
  const LeaderboardUser({
    required this.rank,
    required this.username,
    required this.totalTime,
    required this.todayTime,
    required this.avatarPath,
  });
  final int rank;
  final String username;
  final Duration totalTime;
  final Duration todayTime;
  final String avatarPath;
}
