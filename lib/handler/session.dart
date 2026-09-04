import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/session.dart';
import '../services/dio.dart';

Future<void> createSession(CreateSessionRequest session) async {
  try {
    debugPrint('Sending create session request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/session/create',
      data: session.toJson(),
    );

    debugPrint(response.statusCode.toString());
  } catch (e) {
    debugPrint('Error creating session: $e');
  }
}

Future<List<SessionSelection>> getSessions() async {
  try {
    debugPrint('Sending get sessions request');

    final response = await dio.get('${dotenv.get('API_URL')}/session/all');

    debugPrint(response.statusCode.toString());

    final sessions = List<Map<String, dynamic>>.from(response.data['sessions']);
    return sessions.map(SessionSelection.fromJson).toList();
  } catch (e) {
    debugPrint('Error getting sessions: $e');
    return [];
  }
}

Future<void> joinSession(String name, ownerUsername) async {
  try {
    debugPrint('Sending join session request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/session/join',
      data: {'name': name, 'owner_username': ownerUsername},
    );

    debugPrint(response.statusCode.toString());
  } catch (e) {
    debugPrint('Error joining session: $e');
  }
}

Future<SessionData?> getSession(String name, ownerUsername) async {
  try {
    debugPrint('Sending get session request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/session/named',
      data: {'name': name, 'owner_username': ownerUsername},
    );

    debugPrint(response.statusCode.toString());
    return SessionData.fromJson(Map<String, dynamic>.from(response.data));
  } catch (e) {
    debugPrint('Error getting session: $e');
    return null;
  }
}
