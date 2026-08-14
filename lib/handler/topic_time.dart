import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../services/dio.dart';

Future<(int?, int?)> getTopicTime(String name) async {
  try {
    debugPrint('Sending get topic time request');

    final response = await dio.get(
      '${dotenv.get('API_URL')}/topic/named',
      data: {'name': name},
    );

    debugPrint(response.statusCode.toString());

    return (
      response.data['total_time_tracked_seconds'] as int?,
      response.data['streak'] as int?,
    );
  } catch (e) {
    debugPrint('Error getting topic time: $e');
    return (null, null);
  }
}
