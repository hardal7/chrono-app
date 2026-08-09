import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<List<LeaderboardUser>> getTopUsers() async {
  try {
    debugPrint('Sending get top users request');
    final response = await dio.get(
      '${dotenv.get('API_URL')}/user/top',
      data: {
        // TODO
        'cursor': 100000,
        'limit': 20,
      },
    );
    debugPrint(response.statusCode.toString());
    final users = List<Map<String, dynamic>>.from(response.data['users']);
    return users.map(LeaderboardUser.fromJson).toList();
  } catch (e) {
    return [];
  }
}

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
