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

class CreateSessionRequest {
  CreateSessionRequest({
    required this.name,
    this.maxParticipants,
    this.password,
    this.expiresAt,
    this.topic,
  });
  final String name;
  final int? maxParticipants;
  final String? password;
  final DateTime? expiresAt;
  final String? topic;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (maxParticipants != null) 'max_participants': maxParticipants,
      if (password != null) 'password': password,
      if (expiresAt != null) 'expires_at': expiresAt!.toIso8601String(),
      if (topic != null) 'topic': topic,
    };
  }
}

class MinParticipant {
  const MinParticipant({required this.name, required this.avatarPath});

  factory MinParticipant.fromJson(Map<String, dynamic> json) {
    return MinParticipant(
      name: json['name'] as String,
      avatarPath: json['avatar_path'] as String,
    );
  }
  final String name;
  final String avatarPath;
}

class SessionSelection {
  const SessionSelection({
    required this.name,
    required this.ownerUsername,
    required this.ownerAvatarPath,
    required this.expiresAt,
    required this.totalTime,
    required this.totalParticipants,
    required this.maxParticipants,
    required this.participants,
  });

  factory SessionSelection.fromJson(Map<String, dynamic> json) {
    return SessionSelection(
      name: json['name'] as String,
      ownerUsername: json['owner_username'] as String,
      ownerAvatarPath: json['owner_avatar_path'] as String,
      expiresAt: DateTime.parse(json['expires_at'] as String),
      totalTime: json['total_time_seconds'] as int,
      totalParticipants: json['total_participants'] as int,
      maxParticipants: json['max_participants'] as int,
      participants: (json['participants'] as List<dynamic>)
          .map((e) => MinParticipant.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final String name;
  final String ownerUsername;
  final String ownerAvatarPath;
  final DateTime expiresAt;
  final int totalTime;
  final int totalParticipants;
  final int maxParticipants;
  final List<MinParticipant> participants;
}
