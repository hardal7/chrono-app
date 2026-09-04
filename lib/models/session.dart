class CreateSessionRequest {
  CreateSessionRequest({
    required this.name,
    this.maxParticipants,
    this.expiresAt,
    this.topic,
  });
  final String name;
  final int? maxParticipants;
  final DateTime? expiresAt;
  final String? topic;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      if (maxParticipants != null) 'max_participants': maxParticipants,
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
    required this.joined,
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
      joined: json['joined'] as bool,
      ownerAvatarPath: json['owner_avatar_path'] as String,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
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
  final bool joined;
  final String ownerAvatarPath;
  final DateTime? expiresAt;
  final int totalTime;
  final int totalParticipants;
  final int maxParticipants;
  final List<MinParticipant> participants;
}

class Participant {
  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      name: json['name'] as String,
      avatarPath: json['avatar_path'] as String,
      sessionTime: json['session_time_tracked_seconds'] as int,
      sessionTimeToday: json['session_time_tracked_today_seconds'] as int,
      lastOnline: json['last_online_seconds_ago'] as int,
    );
  }

  const Participant({
    required this.name,
    required this.avatarPath,
    required this.sessionTime,
    required this.sessionTimeToday,
    required this.lastOnline,
  });

  final String name;
  final String avatarPath;
  final int sessionTime;
  final int sessionTimeToday;
  final int lastOnline;
}

class SessionData {
  factory SessionData.fromJson(Map<String, dynamic> json) {
    return SessionData(
      name: json['name'] as String,
      ownerUsername: json['owner_username'] as String,
      totalTime: json['total_time_tracked_seconds'] as int,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      totalParticipants: json['total_participants'] as int,
      maxParticipants: json['max_participants'] as int,
      participants: List<Map<String, dynamic>>.from(
        json['participants'],
      ).map(Participant.fromJson).toList(),
    );
  }

  const SessionData({
    required this.name,
    required this.ownerUsername,
    required this.totalTime,
    required this.expiresAt,
    required this.totalParticipants,
    required this.maxParticipants,
    required this.participants,
  });

  final String name;
  final String ownerUsername;
  final int totalTime;
  final DateTime? expiresAt;
  final int totalParticipants;
  final int maxParticipants;
  final List<Participant> participants;
}
