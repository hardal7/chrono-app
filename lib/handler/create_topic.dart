import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<void> createTopic(String name) async {
  try {
    debugPrint('Sending create topic request');

    final response = await dio.post(
      '${dotenv.get('API_URL')}/topic/create',
      data: {'name': name},
    );

    debugPrint(response.statusCode.toString());
  } catch (e) {
    debugPrint('Error creating topic: $e');
  }
}
