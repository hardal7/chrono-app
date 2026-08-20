import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/leaderboard.dart';
import '../services/dio.dart';

Future<List<LeaderboardUser>> getTopUsers(
  String scope, {
  String? matchName,
}) async {
  try {
    debugPrint('Sending get top users request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/user/top',
      data: {
        // TODO
        'cursor': 100000,
        'limit': 20,
        'scope': scope,
        if (matchName != null) 'match_name': matchName,
      },
    );

    debugPrint(response.statusCode.toString());

    final users = List<Map<String, dynamic>>.from(response.data['users']);
    return users.map(LeaderboardUser.fromJson).toList();
  } catch (e) {
    return [];
  }
}
