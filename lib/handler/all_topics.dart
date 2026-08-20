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
