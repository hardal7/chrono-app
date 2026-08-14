import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

class Topic {
  Topic({this.name = '', this.time = 0});
  String name;
  int time;
}

Future<List<Topic>> getAllTopics() async {
  try {
    debugPrint('Sending get all topics request');

    final response = await dio.get('${dotenv.get('API_URL')}/topic/all');

    debugPrint(response.statusCode.toString());

    final topics = response.data['topics'] as List;

    return topics.map((topic) {
      return Topic(
        name: topic['name'],
        time: topic['total_time_tracked_seconds'] as int,
      );
    }).toList();
  } catch (e) {
    debugPrint('Error getting all topics: $e');
    return List.empty();
  }
}
