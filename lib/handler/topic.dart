import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/topic.dart';
import '../services/dio.dart';

Future<List<Topic>> getAllTopics() async {
  try {
    debugPrint('Sending get all topics request');

    final response = await dio.get('${dotenv.get('API_URL')}/topic/all');

    debugPrint(response.statusCode.toString());

    final topics = List<Map<String, dynamic>>.from(response.data['topics']);
    return topics.map(Topic.fromJson).toList();
  } catch (e) {
    debugPrint('Error getting all topics: $e');
    return List.empty();
  }
}

Future<int> createTopic(String name) async {
  try {
    debugPrint('Sending create topic request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic/create',
      data: {'name': name},
    );

    return response.statusCode ?? 0;
  } catch (e) {
    return 0;
  }
}

Future<int?> getTimeTopic(String name) async {
  try {
    debugPrint('Sending get topic time request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic/named',
      data: {'name': name},
    );

    debugPrint(response.statusCode.toString());

    return response.data['total_time_tracked_seconds'] as int?;
  } catch (e) {
    debugPrint('Error getting topic time: $e');
    return null;
  }
}

Future<int?> trackTopic(
  String name,
  int timeTrackedSeconds,
  DateTime date,
) async {
  try {
    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic-event/track',
      data: {'topic': name, 'time_seconds': timeTrackedSeconds, 'date': date},
    );
    return response.statusCode;
  } catch (e) {
    return null;
  }
}

Future<int?> getTimeToday({String? topic}) async {
  try {
    debugPrint('Sending get topic time today request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic-event/today',
      data: {
        if (topic != null) 'topics': [topic],
      },
    );

    debugPrint(response.statusCode.toString());

    return response.data['total_time'];
  } catch (e) {
    return null;
  }
}
